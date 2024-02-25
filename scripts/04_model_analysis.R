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

# RMSE Chart ---
# collect RMSEs:
rmse_null <- null_fit |> 
  collect_metrics() |> 
  filter(.metric == "rmse")

rmse_mn <- mn_fit |> 
  collect_metrics() |> 
  filter(.metric == "rmse")

model_results |> 
  collect_metrics() |> 
  filter(.metric == "rmse") |> 
  slice_min(mean, by = wflow_id) |> 
  arrange(mean) |> 
  select("Model Type" = wflow_id, 
         "RMSE" = mean, 
         "Std Error" = std_err, 
         "Number of Computations" = n) |> 
  knitr::kable(digits = c(NA, 2, 4, 0))

education_metrics <- bind_rows(rmse_null |> mutate(model = "Null"),
                           rmse_mn |> mutate(model = "Multinomial"))


rmse_table <- education_metrics |>
  rename(metric = .metric) |>
  rename("SE" = std_err) |>
  rename(RMSE = mean) |>
  rename("Model" = model) |>
  rename("Computations" = n) |>
  select("Model", RMSE, "SE", "Computations") |> 
  knitr::kable(digits = c(NA, 2, 3, 0))

save(education_metrics,rmse_table, file="results/rmse_table.rda")
