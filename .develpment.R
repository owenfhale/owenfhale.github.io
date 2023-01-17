library(rvest)
library(xml2)

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
