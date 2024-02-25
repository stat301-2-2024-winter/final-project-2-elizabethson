# mn fit ---

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

# model specifications ----
mn_mod <- multinom_reg(penalty = tune()) |> 
  set_engine("nnet") |> 
  set_mode("classification")

# define workflows ----
mn_wkflw <- workflow() |> 
  add_model(mn_mod) |> 
  add_recipe(education_recipe)

# fit workflows/models ----
keep_pred <- control_resamples(save_pred = TRUE)

fit_folds_mn <- fit_resamples(
  mn_wkflw, 
  resamples = education_folds,
  control = keep_pred
)

# save ---- 
save(fit_folds_mn, file = "results/fit_folds_mn.rda")

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

# plot
autoplot(mn_tuned, metric = "rmse")

# save ---- 
save(fit_tuned_mn, file = "results/fit_tuned_mn.rda")
