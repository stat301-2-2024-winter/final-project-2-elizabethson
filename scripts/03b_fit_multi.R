# multinomial fit ---

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
mn_spec <- multinom_reg() |> 
  set_mode("classification") |> 
  set_engine("nnet")

# define workflows ----
mn_wkflw <- workflow() |> 
  add_model(mn_spec) |> 
  add_recipe(education_recipe)

# fit workflows/models ----
mn_fit <- fit_resamples(
  mn_wkflw, 
  resamples = education_folds,
  control = control_resamples(save_workflow = TRUE)
)

# save ---- 
save(mn_fit, file = "results/mn_fit.rda")

## ignore for now
# hyperparameter tuning values ----
mn_params <- extract_parameter_set_dials(mn_mod)
# grid
mn_grid <- grid_regular(mn_params, levels = 5)

# fit workflows/models, tuned----
# set seed
set.seed(123)

# fit
mn_tuned <- tune_grid(mn_wkflw,
                       education_folds,
                       grid = mn_grid,
                       control = control_grid(save_workflow = TRUE))

# load again
load(here("results/mn_tuned.rda"))

# save ---- 
save(fit_tuned_mn, file = "results/fit_tuned_mn.rda")
