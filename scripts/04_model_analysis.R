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

# OR
penguins_metrics <- fit_folds_multinom |> 
  collect_metrics() |> 
  mutate(model = "multinomial") |> 
  bind_rows(fit_folds_knn |> collect_metrics() |> mutate(model = "knn")) |> 
  # we are going to choose roc_auc as our metric
  filter(.metric == "roc_auc")

penguins_metrics |> 
  select(model, mean, std_err) |> 
  kbl() |> 
  kable_styling()
elastic_workflow <- elastic_workflow |> 
  finalize_workflow(select_best(tuned_elastic, metric = "rmse"))
# save ---
save(roc_table, file = "results/roc_table.rda")
