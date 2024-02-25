# null fit ---

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
load(here("results/education_recipe.rda"))

# set seed ---
set.seed(123)

# model specifications ----
null_spec <- null_model() |> 
  set_engine("parsnip") |> 
  set_mode("classification")

# define workflows ----
null_wkflw <- workflow() |>
  add_model(null_spec) |> 
  add_recipe(education_recipe)

# fit workflows/models ----
null_fit <- fit_resamples(null_wkflw,
                          resamples = education_folds,
                          control = control_resamples(save_pred = TRUE))

# save ---
save(null_fit, file = "results/null_fit.rda")
