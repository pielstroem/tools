#!/usr/bin/env Rscript

# Todo: also search in *gutenberg_authors$alias* and *gutenberg_authors$aliases*

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

p = arg_parser("Find author IDs in Project Gutenberg.")
p = add_argument(p, "input", help = "Name of an author, part of the name or regular expression")
argv = parse_args(p)

# Find the author name
# ====================

author = grep(argv$input, gutenberg_authors$author, value = T)

id = numeric()
for(current.author in author){
  id = append(id, gutenberg_authors$gutenberg_author_id[gutenberg_authors[2] == current.author])
}

data.frame(id, author)
