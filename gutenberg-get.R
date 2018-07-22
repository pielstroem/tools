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

p = arg_parser("Fetch text from Project Gutenberg by text ID.")
p = add_argument(p, "id", help = "Gutenberg Text ID")
argv = parse_args(p)

# Fetch and pass document 
# =======================

document = gutenberg_download(argv$id)
writeLines(document$text)
