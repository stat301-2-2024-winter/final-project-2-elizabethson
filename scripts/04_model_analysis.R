# Analysis of null and multinomial models (comparisons)

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# parallel processing ---
library(doMC)
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)

# load data ---
load(here("data/education_folds.rda"))
load(here("data/education_split.rda"))

# load preprocessing/feature engineering/recipe ---
load(here("results/education_recipe.rda"))

# load model fits
load(here("results/null_fit.rda"))
load(here("results/mn_fit.rda"))


# ROC --
roc_null <- null_fit |> 
  collect_metrics() |> 
  filter(.metric == "roc_auc")

roc_mn <- mn_fit |> 
  collect_metrics() |> 
  filter(.metric == "roc_auc")

education_metrics <- bind_rows(roc_null |> mutate(model = "Null"),
                               roc_mn |> mutate(model = "Multinomial"))

roc_table <- education_metrics |>
  rename(metric = .metric) |>
  rename("SE" = std_err) |>
  rename(ROC = mean) |>
  rename("Model" = model) |>
  rename("Computations" = n) |>
  select("Model", ROC, "SE", "Computations") |> 
  knitr::kable(digits = c(NA, 2, 3, 0))

roc_table

# save ---
save(roc_table, file = "results/roc_table.rda")
