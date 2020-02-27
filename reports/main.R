library(readr)
library(dplyr)
library(tidyr)
library(rmarkdown)
library(knitr)
#library(kableExtra)

# column defs from stepping summary
col_defs <- cols( "step" = col_character(),
                   "subject" = col_character(),
                   "what" = col_character(),
                   "which" = col_character(),
                   "value" = col_double() )

# input_file <- 'big_stepping_results.csv'
input_file <- '../data/2020-02-25_stepping_summary.csv'

df <- read_csv(input_file, col_types=col_defs) %>% 
  mutate(file_n=0) %>%
  rename(months_ago=step)
  
subjects <- c("anno","candi","path","perf")
whats <- c("count", "accepted_count", "uniq_perf_count", "avg", "max", "min")

# How many candidates are there?
#  Number of candidates is the same across all months_agos
n_candidates <- df %>%
  filter(subject == "candi", which == "all", what == "count") %>%
  group_by(months_ago) %>%
  summarize(sum=sum(value)) %>% pull(sum) %>% first

# How many unique performers are there in the candidates?
#  Number of performers is the same across all months_agos, so just grab one value
n_performers <- df %>%
  filter(subject == "candi", what == "uniq_perf_count") %>%
  group_by(months_ago) %>%
  summarize(sum=max(value)) %>% pull(sum) %>% first

#  How many acceptable candidates are there?
df_candi_1 <- df %>%
  filter(subject == "candi", which == "all", what %in% c("count","accepted_count")) %>%
  group_by(months_ago, what) %>%
  summarize(sum=sum(value)) %>%
  pivot_wider(names_from="what", values_from="sum")

#  How many candidates did each causal pathway accept?
df_path_1 <- df %>%
  filter(subject == "path") %>%
  group_by(months_ago, which) %>%
  summarize(sum=sum(value)) %>%
  pivot_wider(values_from=sum, names_from=months_ago, names_prefix = "months_ago_")

# How many times does each annotation appear in the performers?
#  Filter to omit the stepping annotations
df_anno_1 <- df %>%
  filter(subject == "anno", 
         grepl("psdo", which) | grepl("Achievement", which) ) %>%
  group_by(months_ago, which) %>%
  summarize(sum=sum(value)) %>%
  pivot_wider(values_from=sum, names_from=months_ago, names_prefix = "months_ago_")

df_perf_1 <- df %>%
  filter(subject == "perf", which %in% c("acceptable_candidates", "candidates")) %>%
  pivot_wider(names_from=c('what'), values_from = value) %>%
  group_by(months_ago, which) %>%
  summarise(avg=mean(avg), max=max(max), min=min(min)) %>%
  pivot_longer(cols=c(-months_ago, -which)) %>%
  pivot_wider(values_from=value, names_from=months_ago, names_prefix = "months_ago_")
  
# Approximate rate of individuals that could recieve a tailored message 
df_perf_2 <- df %>%
  filter(subject == "perf", what == "count", which=="with_accept") %>%
  mutate(tailor_rate=value/n_performers) %>%
  select(-file_n)
  
###################
# GENERATE REPORT #
###################
options(tinytex.engine="pdflatex")
template_path=file.path('preconditions_report_monolithic.Rmd')
render(template_path)
