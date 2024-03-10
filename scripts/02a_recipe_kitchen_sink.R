# set up recipe ---

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data ---
load(here("data/education_folds.rda"))
load(here("data/education_split.rda"))

# recipe ---
education_recipe <- recipe(target ~ ., data = education_train) |> 
  step_dummy(all_nominal_predictors()) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_predictors())

# check recipe
prep_rec <- prep(education_recipe) |> 
  bake(new_data = education_train)
view(prep_rec) |>
  slice_head(n= 10) # 46 predictors

# save recipe
save(education_recipe, file = here("recipes/education_recipe.rda"))

# recipe for tree models ---
education_recipe_tree <- recipe(target ~ ., data = education_train) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_impute_mean(all_numeric_predictors()) |> 
  step_impute_mode(all_nominal_predictors()) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_predictors())

# check recipe
prep_rec <- prep(education_recipe_tree) |> 
  bake(new_data = education_train)
view(prep_rec) |>
  slice_head(n= 10) # 56 predictors

# save recipe
save(education_recipe_tree, file = here("recipes/education_recipe_tree.rda"))


