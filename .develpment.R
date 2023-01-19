
write_file('---\ntitle: ""\n---\n', 'publications.qmd')

for(i in 1:nrow(bib)){
  info <- bib[i,]
  citations <- paste("Google Scholar Citations: ", info$citations[[1]], sep = '')
  title <- paste('###', info$titles)
  url <- info$urls[[1]]
  journal <- paste('[', info$journals[[1]], '](', url, ')',sep = '', collapse = '')
  date <- info$dates[[1]]
  authors <- paste(info$authors[[1]], sep = '', collapse = ', ')
  doi <- info$dois
  link <- paste('[', doi, '](', url, ')',sep = '', collapse = '')
  cite <- paste(journal, date, citations, sep = '&emsp;', collapse = '')
  
  write_file(paste(title, '\n', sep = ''), 'publications.qmd', append = TRUE)
  write_file(paste(authors, '\n\n', sep = ''), 'publications.qmd', append = TRUE)
  
  write_file('<div style="display: flex; justify-content: space-between;">\n\t<p >Left</p>\n\t<p >Center</p>\n\t<p >Right</p>\n</div>')
  
  write_file(paste(cite, '\n\n***\n\n', sep = ''), 'publications.qmd', append = TRUE)
}


write_file('<div style="display: flex; justify-content: space-between;">\n', 'publications.qmd', append = TRUE)
write_file('  <p >Left</p>', 'publications.qmd\n', append = TRUE)
write_file('  <p >Middle</p>\n', 'publications.qmd', append = TRUE)
write_file('  <p >Right</p>\n', 'publications.qmd', append = TRUE)
write_file('  </div>', 'publications.qmd', append = TRUE)

#<div style="display: flex; justify-content: space-between;">
#  <p >Left</p>
#  <p >Middle</p>
#  <p >Right</p>
#  </div>