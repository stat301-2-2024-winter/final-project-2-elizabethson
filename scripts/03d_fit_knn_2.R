# knn fit, pre-processed recipe ---

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
load(here("recipes/education_recipe_trans_tree.rda"))

# set seed ---
set.seed(123)

# model specifications ----
knn_spec <-
  nearest_neighbor(mode = "classification", neighbors = tune()) |> 
  set_engine("kknn")

# define workflows ----
knn_wkflw_2 <- workflow() |> 
  add_model(knn_spec) |> 
  add_recipe(education_recipe_trans_tree)

# hyperparameter tuning values ----
knn_params <- extract_parameter_set_dials(knn_spec)

# grid
knn_grid <- grid_regular(knn_params, levels = 5)

# fit workflows/models ----
# set seed
set.seed(123)
# fit
knn_fit_2 <- tune_grid(knn_wkflw_2,
                       education_folds,
                       grid = knn_grid,
                       control = control_grid(save_workflow = TRUE))

# select best hyperparameters ---
select_best(knn_fit_2, metric = "accuracy") 

# write out results (fitted/trained workflows) ----
save(knn_fit_2, file = here("results/knn_fit_2.rda"))
