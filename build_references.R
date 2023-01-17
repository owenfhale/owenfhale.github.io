library(yaml)
library(xml2)
library(rvest)
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
      full <- paste(paste('**', first, sep = ''), paste(last, '**', sep = ''))
    }else{full <- paste(first, last)}
    
    author_list <- c(author_list, full)
  }
  author_list <- list(author_list)
  authors <- c(authors, author_list)
}

bib <- cbind(titles, authors, journals, dois, urls, dates) |> as.data.frame()
rownames(bib) <- bib$titles |> substring(1, 40)

# scrape google scholar data for citation count

scholar <- read_html("https://scholar.google.com/citations?user=gDywkyIAAAAJ&hl=en&oi=ao") |> html_elements("tbody#gsc_a_b") |> html_elements("tr.gsc_a_tr")

title_pub <- c()
citations <- c()
year <- c()

for (i in 1:length(scholar)){
  title_pub_entry <- scholar[[i]] |> html_elements("td.gsc_a_t") |> xml_text()
  citations_entry <- scholar[[i]] |> html_elements("td.gsc_a_c") |> xml_text()
  year_entry <- scholar[[i]] |> html_elements("td.gsc_a_y") |> xml_text()
  title_pub <- c(title_pub, title_pub_entry)
  citations <- c(citations, citations_entry)
  year <- c(year, year_entry)
}

scholar_df <- cbind(title_pub, citations, year) |> as.data.frame() |> mutate(citations = gsub("\\*", "", citations))
rownames(scholar_df) <- scholar_df$title_pub |> substring(1, 40)
# add citation info to bib

bib <- merge(bib, scholar_df, all.x = TRUE)

########## convert data frame info into markdown text

# write header

write_file('---\ntitle: ""\n---\n', 'publications.qmd')

for(i in 1:nrow(bib)){
  info <- bib[i,]
  citations <- paste("Citations: ", info$citations[[1]], sep = '')
  title <- paste('###', info$titles)
  url <- info$urls[[1]]
  journal <- info$journals[[1]]
  date <- info$dates[[1]]
  authors <- paste(info$authors[[1]], sep = '', collapse = ', ')
  doi <- info$dois
  link <- paste('[', doi, '](', url, ')',sep = '', collapse = '')
  cite <- paste(journal, date, link, citations, sep = '&emsp;', collapse = '')
  
  write_file(paste(title, '\n', sep = ''), 'publications.qmd', append = TRUE)
  write_file(paste(authors, '\n\n', sep = ''), 'publications.qmd', append = TRUE)
  write_file(paste(cite, '\n\n', sep = ''), 'publications.qmd', append = TRUE)
}


