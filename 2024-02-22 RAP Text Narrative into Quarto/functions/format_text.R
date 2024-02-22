
# Format text chunks so Markdown can be read directly into the Quarto file

format_text <- function(docpart) {
  
  # separate paragraphs at line breaks
  doclines <- str_split(docpart, "\n")[[1]]
  
  # for each paragraph, write the text adding line breaks as required 
  for (line in doclines) { 
    if (substr(line, 1, 2) == '##') {
      cat("\n")
      cat(line)
    } else if (substr(line, 1, 1) == '#') {
        cat(line)
    } else { 
        cat("\n", line, "\n\n")
    }
  }
} 

