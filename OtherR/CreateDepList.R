## Create the lookup table

library(tidyverse)

masterlistloc <- "Data/MasterList.txt"

dep_list <- readLines(file.path(masterlistloc),
                        #n = 2,
                        skipNul = TRUE,
                        warn = FALSE)

dep_list2 <- dep_list %>%
  as_tibble() %>%
  mutate(dependency = ifelse(!str_detect(value, "#"), value, NA)) %>%
  mutate(value = ifelse(str_detect(value, "#"), value, NA)) %>%
  fill(value, .direction = "down") %>%
  filter(!dependency == "") %>%
  mutate(value = str_extract(value, "(?<=#\\s)(.*)(?=\\srequirements)")) %>%
  rename(package = value) %>%
  mutate(type =
           case_when(str_detect(dependency, "apt-get") ~ "apt-get",
                     str_detect(dependency, "R CMD") ~ "R CMD",
                     TRUE ~ "Other")) %>%
  filter(!str_detect(dependency, "apt-get update"))

  # mutate(type = ifelse(lag(type, 2) == "Other" | lag(type, 1) == "Other", "Other", type)) %>%
  # mutate(type =
  #          case_when(is.na(type) & str_detect(dependency, "apt-get") ~ "apt-get",
  #                    is.na(type) & str_detect(dependency, "R CMD") ~ "R CMD",
  #                    TRUE ~ type))

dep_list2 %>%
  write_csv("Data/DepList.csv")
