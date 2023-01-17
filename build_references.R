library(yaml)
suppressPackageStartupMessages(library(tidyverse))

# import references from yaml
references <- read_yaml('references.yaml')[[1]]

# make data frame of reference info
titles   <- c()
authors  <- c()
journals <- c()
dois     <- c()
urls     <- c()
dates    <- c()

for (i in 1:length(references)){
  p <- references[i][[1]]
  titles   <- c(titles, p$title)
  journals <- c(journals, p$`container-title`)
  dois     <- c(dois, p$DOI)
  urls     <- c(urls, p$URL)
  dates    <- c(dates, p$issued)
  author_list <- c()
  for (a in 1:length(p$author)){
    first <- p$author[a][[1]]$given
    last  <- p$author[a][[1]]$family
    
    if (grepl('Owen', first) & grepl('Hale', last)){
      full <- paste(paste('', first, sep = ''), paste(last, '', sep = ''))
    }else{full <- paste(first, last)}
    
    author_list <- c(author_list, full)
  }
  author_list <- list(author_list)
  authors <- c(authors, author_list)
}

bib <- cbind(titles, authors, journals, dois, urls, dates) |> as.data.frame()

########## convert data frame info into markdown text

# write header

write_file('---\ntitle: "Publications"\n---\n', 'publications.qmd')

for(i in 1:nrow(bib)){
  info <- bib[i,]
  title <- paste('####', info$titles)
  url <- info$urls[[1]]
  journal <- info$journals[[1]]
  date <- info$dates[[1]]
  authors <- paste(info$authors[[1]], sep = '', collapse = ', ')
  doi <- info$dois
  link <- paste('[', doi, '](', url, ')',sep = '', collapse = '')
  cite <- paste(journal, date, link, sep = '\t\t', collapse = '')
  
  write_file(paste(title, '\n', sep = ''), 'publications.qmd', append = TRUE)
  write_file(paste(authors, '\n\n', sep = ''), 'publications.qmd', append = TRUE)
  write_file(paste(cite, '\n\n', sep = ''), 'publications.qmd', append = TRUE)
}


