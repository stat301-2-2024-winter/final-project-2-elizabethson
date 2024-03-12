# training the final model (boosted tree kitchen sink) ---

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data ---
load(here("data/education_folds.rda"))
load(here("data/education_split.rda"))

# load best model ---
load(here("results/bt_fit.rda"))

# finalize workflow
final_wflow <- bt_fit |> 
  extract_workflow(bt_fit) |>  
  finalize_workflow(select_best(bt_fit, metric = "roc_auc"))

# train final model
# set seed
set.seed(123)
final_fit <- fit(final_wflow, education_train)

# save
save(final_fit, file = here("results/final_fit.rda"))