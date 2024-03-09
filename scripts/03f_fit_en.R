# rf fit ---

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
rf_spec <- 
  rand_forest(
    mode = "regression",
    trees = 1000, 
    min_n = tune(),
    mtry = tune()
  ) |> 
  set_engine("ranger")

# define workflows ----
rf_workflow <- workflow() |> 
  add_model(rf_spec) |> 
  add_recipe(education_recipe)

# hyperparameter tuning values ----
rf_params <- extract_parameter_set_dials(rf_spec) |>  
  # N:= maximum number of random predictor columns we want to try 
  # should be less than the number of available columns
  update(mtry = mtry(c(1, 14))) 

# build tuning grid
rf_grid <- grid_regular(rf_params, levels = 5)

# fit workflows/models ----
# fit
rf_tuned <- tune_grid(rf_workflow,
                      education_folds,
                      grid = rf_grid,
                      control = control_grid(save_workflow = TRUE))

# plot
autoplot(rf_tuned, metric = "roc")

# save (fitted/trained workflows) ----
save(rf_tuned, file = here("results/rf_tuned.rda"))