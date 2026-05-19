################################################################################
# Scrape FFA
################################################################################

# Dependencies ------------------------------------------------------------

if (!"needs" %in% installed.packages()) {
  install.packages("needs")
}
needs::needs(tidyverse, rvest, here)


# Scrape ------------------------------------------------------------------

url <- "https://www.ffa.de/foerderentscheidungen-uebersicht.html"

hrefs <- url %>%
  read_html() %>%
  html_elements("a[href$='.pdf']") %>%
  html_attr("href")

sources <- tibble(
  filename = basename(hrefs),
  url = paste0("https://www.ffa.de/", hrefs)
)

dest_dir <- here("src", "data", "raw", "pdf", "ffa")

if (!dir.exists(dest_dir)) {
  dir.create(dest_dir, recursive = TRUE)
}

walk2(sources$filename, sources$url, \(filename, url) {
  download.file(url, file.path(dest_dir, filename))
})

write_csv(sources, here("src", "sources", "ffa.csv"))
