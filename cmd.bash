pandoc -f markdown -t html -o specs-techniques-flux.html all-docs.md
pandoc -f markdown -t docx -o specs-techniques-flux.docx --reference-doc=modele.dotx  all-docs.md