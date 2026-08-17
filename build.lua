module = "texchanges"

sourcefiles = {"texchanges.sty", "texchanges-doc.tex"}
installfiles = {"texchanges.sty"}
typesetfiles = {"texchanges-doc.tex"}
typesetexe = "pdflatex"
textfiles = {"README.md", "CHANGELOG.md", "LICENSE"}

checkengines = {"pdftex", "xetex", "luatex"}
stdengine = "pdftex"
checkruns = 2
checkformat = "latex"
-- Log-level regression tests: these assert the public API surface, the
-- compatibility aliases, and the localization string defaults, which the
-- PDF-text assertions in scripts/test.sh cannot see.
testfiledir = "testfiles"

uploadconfig = {
  pkg = "texchanges",
  version = "0.3.0",
  author = "Phuc Nguyen",
  license = "lppl1.3c",
  summary = "LaTeX-native track changes for human and AI-assisted review",
  ctanPath = "/macros/latex/contrib/texchanges",
  repository = "https://github.com/phucnht/texchanges",
  bugtracker = "https://github.com/phucnht/texchanges/issues",
  update = true,
}
