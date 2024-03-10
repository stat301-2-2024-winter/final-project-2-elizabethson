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
load(here("recipes/education_recipe.rda"))

# load model fits
load(here("results/null_fit.rda"))
load(here("results/mn_tuned.rda"))


# ROC --
select_best(null_fit, metric = "roc_auc")
select_best(mn_tuned, metric = "roc_auc")

roc_null <- null_fit |> 
  collect_metrics() |> 
  filter(.metric == "roc_auc")

roc_mn <- mn_tuned |> 
  collect_metrics() |> 
  filter(.metric == "roc_auc")

education_metrics <- bind_rows(roc_null |> mutate(model = "Null"),
                               roc_mn |> mutate(model = "Multinomial"))

roc_table <- education_metrics |>
  slice_min(mean, by = wflow_id) |> 
  arrange(mean) |> 
  select("Model" = model, 
         "ROC" = mean,
         "Computations" = n,
         "SE" = std_err) |> 
  knitr::kable(digits = c(NA, 2, 3, 0))

roc_table