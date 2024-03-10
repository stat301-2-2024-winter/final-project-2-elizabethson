# en fit, kitchen sink recipe ---

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
en_spec <- 
  multinom_reg(
    mode = "classification",
    penalty = tune(),
    mixture = tune()
  ) |> 
  set_engine("glmnet")

# define workflows ----
en_workflow <- workflow() |> 
  add_model(en_spec) |> 
  add_recipe(education_recipe)

# hyperparameter tuning values ----
en_params <- extract_parameter_set_dials(en_spec) |>  
  update(penalty = penalty(c(0, 1))) |> 
  update(mixture = mixture(c(0, 1)))

# build tuning grid
en_grid <- grid_regular(en_params, levels = 5)

# fit workflows/models ----
# set seed
set.seed(123)
# fit
en_tuned <- tune_grid(en_workflow,
                      education_folds,
                      grid = en_grid,
                      control = control_grid(save_workflow = TRUE))

# select best hyperparameters ---
select_best(en_tuned, metric = "accuracy") # best hyperparameters: penalty = 1, mixture = 0

# write out results (fitted/trained workflows) ----
save(en_tuned, file = here("results/en_tuned.rda"))
