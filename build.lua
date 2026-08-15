module = "texchanges"

sourcefiles = {"texchanges.sty", "texchanges-doc.tex"}
installfiles = {"texchanges.sty"}
typesetfiles = {"texchanges-doc.tex"}
typesetexe = "pdflatex"
textfiles = {"README.md", "CHANGELOG.md", "LICENSE"}

checkengines = {"pdftex", "xetex", "luatex"}
checkruns = 2

uploadconfig = {
  pkg = "texchanges",
  version = "0.2.3",
  author = "Phuc Nguyen",
  license = "lppl1.3c",
  summary = "LaTeX-native track changes for human and AI-assisted review",
  ctanPath = "/macros/latex/contrib/texchanges",
  repository = "https://github.com/phucnht/texchanges",
  bugtracker = "https://github.com/phucnht/texchanges/issues",
  update = true,
}
