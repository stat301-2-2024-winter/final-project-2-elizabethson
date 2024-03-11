# Analysis of all 12 models (comparisons)

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

# load model fits ---
load(here("results/null_fit.rda"))
load(here("results/mn_fit.rda"))
load(here("results/bt_fit.rda"))
load(here("results/knn_fit.rda"))
load(here("results/rf_fit.rda"))
load(here("results/en_fit.rda"))
load(here("results/null_fit_2.rda"))
load(here("results/mn_fit_2.rda"))
load(here("results/bt_fit_2.rda"))
load(here("results/knn_fit_2.rda"))
load(here("results/rf_fit_2.rda"))
load(here("results/en_fit_2.rda"))

# ROC --
select_best(null_fit, metric = "roc_auc")
select_best(mn_fit, metric = "roc_auc")
select_best(rf_fit, metric = "roc_auc")

roc_null <- null_fit |> 
  collect_metrics() |> 
  filter(.metric == "roc_auc")

roc_mn <- mn_tuned |> 
  collect_metrics() |> 
  filter(.metric == "roc_auc") |> 
  arrange(desc(mean)) |> 
  slice_head(n = 1)

# another way
mn_tuned_best <- show_best(mn_tuned, metric = "roc_auc")[1,]

education_metrics <- bind_rows(roc_null |> mutate(model = "Null"),
                               roc_mn |> mutate(model = "Multinomial")) |> 
  mutate(recipe = c("Kitchen Sink", "Kitchen Sink"))

roc_table <- education_metrics |>
  select("Model" = model, 
         "ROC" = mean,
         "Computations" = n,
         "SE" = std_err,
         "recipe" = recipe) |> 
  knitr::kable(digits = c(NA, 2, 3, 0))

roc_table
