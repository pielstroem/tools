#!/usr/bin/env Rscript

# Handle dependencies
# ===================

package.list = c("argparser", "gutenbergr")

handle.package = function(package.name){
  if(!is.element(package.name, installed.packages()[,1])){
    install.packages(package.name)
  }
  library(package.name, character.only = TRUE)
}

for(package in package.list){
  handle.package(package)
}

# Pass arguments
# ==============

p = arg_parser("Strip headers nd footers from a Project Gutenberg document.")
p = add_argument(p, "document", help = "Document to be stripped")
argv = parse_args(p)

# Strip and return document
# =========================

document = scan(argv$document, what = "character", sep = "\n")
#document = paste(document, collapse = " ")
document = gutenberg_strip(document)
#writeLines(document)
print(document)