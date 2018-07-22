#!/usr/bin/env Rscript

# Todo: Doesn't yet return graphical output!

# Handle dependencies

package.list = c("stylo")

handle.package = function(package.name){
  if(!is.element(package.name, installed.packages()[,1])){
    install.packages(package.name)
  }
  library(package.name, character.only = TRUE)
}

for(package in package.list){
  handle.package(package)
}

# Run stylo

stylo()