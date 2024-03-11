# bt fit, kitchen sink recipe ---

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
bt_spec <- boost_tree(mode = "classification", 
                      min_n = tune(),
                      mtry = tune(), 
                      trees = 500,
                      learn_rate = tune()) |> 
  set_engine("xgboost")

# define workflows ----
bt_wkflw <- workflow() |> 
  add_model(bt_spec) |> 
  add_recipe(education_recipe_tree)

# hyperparameter tuning values ----
bt_params <- extract_parameter_set_dials(bt_spec) |> 
  update(mtry = mtry(c(1, 7))) |> 
  update(learn_rate = learn_rate(c(-5, -0.2)))

# build tuning grid
bt_grid <- grid_regular(bt_params, levels = 5)

# fit workflows/models ----
# set seed
set.seed(123)
# fit
bt_fit <- tune_grid(bt_wkflw,
                      education_folds,
                      grid = bt_grid,
                      control = control_grid(save_workflow = TRUE))

# select best hyperparameters ---
select_best(bt_fit, metric = "roc_auc") # best hyperparameters: mtry = 7, min_n = 11, learn_rate = .631

# write out results (fitted/trained workflows) ----
save(bt_fit, file = here("results/bt_fit.rda"))
