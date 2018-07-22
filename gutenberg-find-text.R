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

p = arg_parser("Find a text in Project Gutenberg.")
p = add_argument(p, "input", help = "Search for...")
p = add_argument(p, "--criterium", help = "*title*, *author*, *textid* or *authorid*", default = "title")
p = add_argument(p, "--language", help = "Language code, pass argument *list-languages* for a complete list.", default = "en")
argv = parse_args(p)

# Find the texts
# ==============

df = gutenberg_metadata[gutenberg_metadata$has_text == TRUE,]
df = df[df$language == argv$language,]
if(argv$criterium == "title"){
  text = unique(grep(argv$input, gutenberg_metadata$title, value = TRUE))
  df = df[df$title == text,]
  df = df[!is.na(df$gutenberg_id),]
} else if(argv$criterium == "author"){
  author = unique(grep(argv$input, gutenberg_metadata$author, value = TRUE))
  df = df[df$author == author,]
  df = df[!is.na(df$gutenberg_id),]
} else if(argv$criterium == "textid"){
  df = df[df$gutenberg_id == argv$input,]
  df = df[!is.na(df$gutenberg_id),]
} else if(argv$criterium == "authorid"){
  author = unique(grep(argv$input, gutenberg_metadata$author, value = TRUE))
  df = df[df$gutenberg_author_id == argv$input,]
  df = df[!is.na(df$gutenberg_id),]
} else {
  stop("Criterium for selection must be *title*, *author*, *textid* or *authorid*!")
}

# Manage the output
# =================

ID = df[1]
title = df[2]
author = df[3]
authorID = df[4]

if(nrow(df) < 1){
  stop("No match found!")
} else if(argv$input == "list-languages"){
  unique(gutenberg_metadata$language)
} else {
  data.frame(authorID, author, ID, title)
}
