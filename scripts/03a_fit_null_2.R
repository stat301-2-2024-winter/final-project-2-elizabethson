# null fit, pre-processed recipe ---

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

# load preprocessing/feature engineering/recipe
load(here("recipes/education_recipe_trans.rda"))

# set seed ---
set.seed(123)

# model specifications ----
null_spec <- null_model() |> 
  set_engine("parsnip") |> 
  set_mode("classification")

# define workflows ----
null_wkflw_2 <- workflow() |>
  add_model(null_spec) |> 
  add_recipe(education_recipe_trans)

# fit workflows/models ----
null_fit_2 <- fit_resamples(null_wkflw_2,
                          resamples = education_folds,
                          control = control_resamples(save_workflow = TRUE))

# save ---
save(null_fit_2, file = "results/null_fit_2.rda")
