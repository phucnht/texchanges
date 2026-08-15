import ast
import contextlib
import importlib.util
import io
import os
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

SCRIPT = Path(__file__).parents[1] / "scripts" / "texchanges-merge.py"
SPEC = importlib.util.spec_from_file_location("texchanges_merge", SCRIPT)
assert SPEC is not None and SPEC.loader is not None
MODULE = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = MODULE
SPEC.loader.exec_module(MODULE)

ParseError = MODULE.ParseError
main = MODULE.main
parse_changes = MODULE.parse_changes
transform = MODULE.transform


class MergeTests(unittest.TestCase):
    def test_script_uses_only_standard_library_imports(self):
        tree = ast.parse(SCRIPT.read_text(encoding="utf-8"))
        imported = {
            alias.name.split(".", 1)[0]
            for node in ast.walk(tree)
            if isinstance(node, ast.Import)
            for alias in node.names
        }
        imported.update(
            node.module.split(".", 1)[0]
            for node in ast.walk(tree)
            if isinstance(node, ast.ImportFrom) and node.module != "__future__"
        )
        standard_library = {
            "argparse",
            "dataclasses",
            "difflib",
            "pathlib",
            "re",
            "shutil",
            "sys",
        }
        self.assertTrue(imported <= standard_library)

    def test_version_output(self):
        result = subprocess.run(
            [sys.executable, str(SCRIPT), "--version"],
            check=False,
            capture_output=True,
            text=True,
        )
        self.assertEqual(result.returncode, 0)
        self.assertEqual(result.stdout, "texchanges-merge 0.2.3\n")
        self.assertEqual(result.stderr, "")

    def test_help_remains_readable_in_narrow_terminal(self):
        environment = os.environ.copy()
        environment["COLUMNS"] = "10"
        result = subprocess.run(
            [sys.executable, str(SCRIPT), "--help"],
            check=False,
            capture_output=True,
            text=True,
            env=environment,
        )
        self.assertEqual(result.returncode, 0)
        self.assertIn(
            "Resolve or merge Texchanges markup without third-party dependencies.",
            result.stdout,
        )
        for description in (
            "LaTeX source file containing Texchanges markup",
            "destination file for the updated source",
            "accept matching changes",
            "print a unified diff without writing files",
        ):
            self.assertIn(description, result.stdout)

    def test_executable_symlink_is_working_directory_independent(self):
        with tempfile.TemporaryDirectory() as directory:
            link = Path(directory) / "texchanges-merge"
            link.symlink_to(SCRIPT)
            result = subprocess.run(
                [str(link), "--version"],
                cwd=Path(directory).parent,
                check=False,
                capture_output=True,
                text=True,
            )
        self.assertEqual(result.returncode, 0)
        self.assertEqual(result.stdout, "texchanges-merge 0.2.3\n")

    def test_native_nested_and_unicode(self):
        source = r"Before \txreplace[author=a,id=R1]{old {nested}}{mới {nested}} after"
        self.assertIn("mới {nested}", transform(source, decision="accept", merge=True))
        self.assertIn("old {nested}", transform(source, decision="reject", merge=True))

    def test_compat_replacement_order(self):
        source = r"\replaced[id=phuc,changeid=R2]{new}{old}"
        self.assertEqual(transform(source, decision="accept", merge=True), "new")
        self.assertEqual(transform(source, decision="reject", merge=True), "old")

    def test_filters_and_status_update(self):
        source = r"\txadd[author=a,id=A]{one} \txadd[author=b,id=B]{two}"
        result = transform(source, decision="accept", merge=False, author="a")
        self.assertIn("status={accepted}", result)
        self.assertIn(r"\txadd[author=b,id=B]{two}", result)

    def test_comments_and_verbatim_are_skipped(self):
        source = "% \\txadd{comment}\n\\begin{verbatim}\n\\txadd{code}\n\\end{verbatim}\n\\txadd{real}"
        result = transform(source, decision="accept", merge=True)
        self.assertIn(r"\txadd{comment}", result)
        self.assertIn(r"\txadd{code}", result)
        self.assertTrue(result.endswith("real"))

    def test_highlight_and_comment_cleanup(self):
        source = r"\txhighlight{keep} \txcomment{drop}"
        self.assertEqual(transform(source, decision="accept", merge=True), "keep ")

    def test_highlight_and_comment_status_update(self):
        source = r"\txhighlight[author=a,id=H]{keep} \txcomment[author=a,id=C]{note}"
        result = transform(source, decision="reject", merge=False, author="a")
        self.assertEqual(result.count("status={rejected}"), 2)

    def test_native_and_compat_highlight_metadata(self):
        native = parse_changes(r"\txhighlight[author=a,id=H]{native}")[0]
        compat = parse_changes(r"\highlight[id=a,changeid=H]{compat}")[0]
        self.assertEqual((native.author, native.change_id), ("a", "H"))
        self.assertEqual((compat.author, compat.change_id), ("a", "H"))

    def test_malformed_input_fails(self):
        with self.assertRaises(ParseError):
            parse_changes(r"\txadd{broken")

    def test_change_id_filter(self):
        source = r"\txadd[id=A]{one} \txadd[id=B]{two}"
        result = transform(source, decision="reject", merge=True, change_id="B")
        self.assertEqual(result, r"\txadd[id=A]{one} ")

    def test_existing_status_is_replaced(self):
        source = r"\txadd[id=A,status=pending]{one}"
        result = transform(source, decision="accept", merge=False)
        self.assertEqual(result.count("status="), 1)
        self.assertIn("status={accepted}", result)

    def test_dry_run_and_in_place_backup(self):
        with tempfile.TemporaryDirectory() as directory:
            source = Path(directory) / "paper.tex"
            source.write_text(r"\txadd[id=A]{new}", encoding="utf-8")
            stdout = io.StringIO()
            with contextlib.redirect_stdout(stdout):
                self.assertEqual(main([str(source), "--accept", "--merge", "--dry-run"]), 0)
            self.assertIn("+new", stdout.getvalue())
            self.assertEqual(source.read_text(encoding="utf-8"), r"\txadd[id=A]{new}")
            self.assertEqual(main([str(source), "--accept", "--merge", "--in-place"]), 0)
            self.assertEqual(source.read_text(encoding="utf-8"), "new")
            self.assertEqual(Path(str(source) + ".bak").read_text(encoding="utf-8"), r"\txadd[id=A]{new}")

    def test_malformed_input_does_not_write_output(self):
        with tempfile.TemporaryDirectory() as directory:
            source = Path(directory) / "paper.tex"
            output = Path(directory) / "resolved.tex"
            source.write_text(r"\txadd{broken", encoding="utf-8")
            with contextlib.redirect_stderr(io.StringIO()):
                self.assertEqual(main([str(source), str(output), "--accept", "--merge"]), 2)
            self.assertFalse(output.exists())

    def test_output_must_be_distinct(self):
        with tempfile.TemporaryDirectory() as directory:
            source = Path(directory) / "paper.tex"
            source.write_text(r"\txadd{new}", encoding="utf-8")
            with self.assertRaises(SystemExit):
                main([str(source), str(source), "--accept"])


if __name__ == "__main__":
    unittest.main()
