#!/usr/bin/env Rscript

# Handle dependencies
# ===================

package.list = c("argparser")

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

p = arg_parser("Tokenize text file.")
p = add_argument(p, "input", help = "Path to a plain text file")
p = add_argument(p, "--token", help = "*words* or *characters*?", default = "words")
p = add_argument(p, "--punctuation", help = "Keep punctuation", default = FALSE)
p = add_argument(p, "--lowercase", help = "Convert everything to lower case", default = TRUE)
argv <- parse_args(p)

if(argv$token != "words" & argv$token != "characters"){
  stop("--token must be specified either as *words* or *characters*")
}

#' A tokenizer that allows to preserve punctuation
#' ===============================================
#'
#' **Input**
#' - path to a plaintext file
#'
#' **toDo**
#' - xml-support, i.e. automatic markup removal
#'
my.tokenize = function(path,
                       token = "words",
                       punctuation = F,
                       tolower = F
                       ){
  text = scan(path, what = "character", sep = "\n")
  text = paste(text, collapse = " ")
  if(tolower == T){
    text = tolower(text)
  }
  if(punctuation == F){
    if(token == "words"){
      text = strsplit(text, "\\W")
    }
    if(token == "characters"){
      text = gsub("[[:punct:]]", " ", text)
      text = strsplit(text, "")
    }
  }
  if(punctuation == T){
    if(token == "words"){
      # replace punctuation
      text = gsub("[.]", " PUNCpoint", text)
      text = gsub("[,]", " PUNCcomma", text)
      text = gsub("[;]", " PUNCsemic", text)
      text = gsub("[!]", " PUNCexcla", text)
      text = gsub("[?]", " PUNCquest", text)
      text = gsub("[:]", " PUNCcolon", text)
      # remove the other special characters
      text = strsplit(text, "\\W")
      # get the symbols back
      text = unlist(text)
      text = replace(text, text == "PUNCpoint", ".")
      text = replace(text, text == "PUNCcomma", ",")
      text = replace(text, text == "PUNCsemic", ";")
      text = replace(text, text == "PUNCexcla", "!")
      text = replace(text, text == "PUNCquest", "?")
      text = replace(text, text == "PUNCcolon", ":")
    }
    if(token == "characters"){
      # replace punctuation
      text = gsub("[.]", " PUNCpoint", text)
      text = gsub("[,]", " PUNCcomma", text)
      text = gsub("[;]", " PUNCsemic", text)
      text = gsub("[!]", " PUNCexcla", text)
      text = gsub("[?]", " PUNCquest", text)
      text = gsub("[:]", " PUNCcolon", text)
      # remove the other special characters
      text = gsub("[[:punct:]]", " ", text)
      # put back the original symbols
      text = gsub(" PUNCpoint", ".", text)
      text = gsub(" PUNCcomma", ",", text)
      text = gsub(" PUNCsemic", ";", text)
      text = gsub(" PUNCexcla", "!", text)
      text = gsub(" PUNCquest", "?", text)
      text = gsub(" PUNCcolon", ":", text)
      # now split to characters
      text = strsplit(text, "")
    }
  }
  text = unlist(text)
  whitespace = text == "" | text == " "
  text = text[whitespace == F]
  return(text)
}

# Eexecute function with external arguments
# =========================================

result = my.tokenize(argv$input, token = argv$token, punctuation = argv$punctuation, tolower = argv$lowercase)
writeLines(result)
