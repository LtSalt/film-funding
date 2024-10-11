################################################################################
# Scrape FFA
################################################################################


# Dependencies ------------------------------------------------------------

if (!"pacman" %in% installed.packages()) install.packages("pacman")
pacman::p_load(tidyverse, rvest, here)


# Scrape ------------------------------------------------------------------

url <- "https://www.ffa.de/foerderentscheidungen-uebersicht.html"

sources <- url %>% 
  read_html() %>% 
  html_elements(".download-element.ext-pdf > a") %>% 
  map(html_attrs) %>% 
  map(\(node) magrittr::extract(node, c("title", "href"))) %>% 
  bind_rows() %>% 
  reframe(title = str_extract(title, "^Die Datei (.+\\.pdf) herunterladen", 1),
          url = paste0("https://www.ffa.de/", href)) %>% 
  filter(!str_detect(title, "2024"))

walk2(sources$title, sources$url, 
      \(title, url) download.file(url, here("src", "data", "raw", "pdf", "ffa", title)))
