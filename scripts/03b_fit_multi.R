# multinomial fit, kitchen sink recipe ---

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
load(here("recipes/education_recipe.rda"))

# set seed ---
set.seed(123)

# model specifications ----
mn_spec <- multinom_reg(mode = "classification", 
                      penalty = tune()) |> 
  set_engine("nnet")

# define workflows ----
mn_wkflw <- workflow() |> 
  add_model(mn_spec) |> 
  add_recipe(education_recipe)

# hyperparameter tuning values ----
mn_params <- extract_parameter_set_dials(mn_spec) |> 
  update(penalty = penalty(range = c(-10, 0)))

# grid
mn_grid <- grid_regular(mn_params, levels = 5)

# fit workflows/models ----
mn_tuned <- tune_grid(mn_wkflw,
                      education_folds,
                      grid = mn_grid,
                      control = control_grid(save_workflow = TRUE))

# select best hyperparameters ---
select_best(mn_tuned, metric = "accuracy") # best hyperparameters: penalty = 1

# save ---- 
save(mn_tuned, file = "results/mn_tuned.rda")