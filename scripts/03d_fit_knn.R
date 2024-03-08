# knn fit ---

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
knn_spec <-
  nearest_neighbor(mode = "regression", neighbors = tune()) |> 
  set_engine("kknn")

# define workflows ----
knn_workflow <- workflow() |> 
  add_model(knn_spec) |> 
  add_recipe(education_recipe)
knn_params <- extract_parameter_set_dials(knn_spec)
neighbors()
# grid
knn_grid <- grid_regular(knn_params, levels = 5)

# fit workflows/models ----
knn_tuned <- tune_grid(knn_workflow,
                       education_folds,
                       grid = knn_grid,
                       control = control_grid(save_workflow = TRUE))

# save (fitted/trained workflows) ----
save(knn_tuned, file = here("results/knn_tuned.rda"))

