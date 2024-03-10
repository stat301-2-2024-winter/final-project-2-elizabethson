# rf fit, kitchen sink recipe ---

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
load(here("recipes/education_recipe_tree.rda"))

# set seed ---
set.seed(123)

# model specifications ----
rf_spec <- 
  rand_forest(
    mode = "classification",
    trees = 500, 
    min_n = tune(),
    mtry = tune()
  ) |> 
  set_engine("ranger")

# define workflows ----
rf_workflow <- workflow() |> 
  add_model(rf_spec) |> 
  add_recipe(education_recipe_tree)

# hyperparameter tuning values ----
rf_params <- extract_parameter_set_dials(rf_spec) |>
  update(mtry = mtry(c(1, 7))) 

# build tuning grid
rf_grid <- grid_regular(rf_params, levels = 5)

# fit workflows/models ----
rf_tuned <- tune_grid(rf_workflow,
                      education_folds,
                      grid = rf_grid,
                      control = control_grid(save_workflow = TRUE))

# select best hyperparameters ---
select_best(rf_tuned, metric = "accuracy") # best hyperparameters: mtry = 7, min_n = 11

# write out results (fitted/trained workflows) ----
save(rf_tuned, file = here("results/rf_tuned.rda"))
