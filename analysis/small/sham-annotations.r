library(tidyr)
library(dplyr)

setup_cache <- function(data, spek){
  cache <- list()
  return(cache)
}

annotate_negative_gap <- function(data, spek){
  id <- rlang::sym('id')

  data %>%
    group_by(!!id) %>%
    summarize(negative_gap = TRUE)
}
