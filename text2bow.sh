#!/usr/bin/env bash
#based on Janssens, 2018: Data Science at the Command Line https://www.datascienceatthecommandline.com/chapter-4-creating-reusable-command-line-tools.html
grep -oE '\w+' $1 | sort | uniq -c | sort -nr
