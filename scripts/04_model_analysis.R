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

model_results |> 
  collect_metrics() |> 
  filter(.metric == "roc_auc") |> 
  slice_min(mean, by = wflow_id) |> 
  arrange(mean) |> 
  select("Model Type" = wflow_id, 
         "RMSE" = mean, 
         "Std Error" = std_err, 
         "Number of Computations" = n) |> 
  knitr::kable(digits = c(NA, 2, 4, 0))
