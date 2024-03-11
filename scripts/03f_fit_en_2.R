# en fit, pre-processed recipe ---

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
load(here("recipes/education_recipe_trans.rda"))

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
en_wkflw_2 <- workflow() |> 
  add_model(en_spec) |> 
  add_recipe(education_recipe_trans)

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
en_fit_2 <- tune_grid(en_wkflw_2,
                      education_folds,
                      grid = en_grid,
                      control = control_grid(save_workflow = TRUE))

# select best hyperparameters ---
select_best(en_fit_2, metric = "roc_auc") 

# write out results (fitted/trained workflows) ----
save(en_fit_2, file = here("results/en_fit_2.rda"))
