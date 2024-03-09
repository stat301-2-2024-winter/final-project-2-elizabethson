# bt fit ---

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
bt_spec <- boost_tree(mode = "classification", 
                      min_n = tune(),
                      mtry = tune(), 
                      learn_rate = tune()) |> 
  set_engine("xgboost")

# define workflows ----
bt_workflow <- workflow() |> 
  add_model(bt_spec) |> 
  add_recipe(educarion_recipe)

# hyperparameter tuning values ----
bt_params <- extract_parameter_set_dials(bt_spec) |> 
  update(mtry = mtry(c(1, 14))) |> 
  update(learn_rate = learn_rate(c(-5, -0.2)))

# build tuning grid
bt_grid <- grid_regular(bt_params, levels = 5)

# fit workflows/models ----
# set seed
set.seed(123)
# fit
bt_tuned <- tune_grid(bt_workflow,
                      education_folds,
                      grid = bt_grid,
                      control = control_grid(save_workflow = TRUE))

# plot
autoplot(bt_tuned, metric = "roc")

# write out results (fitted/trained workflows) ----
save(bt_tuned, file = here("results/bt_tuned.rda"))