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
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_predictors())

# check recipe
prep_rec <- prep(education_recipe) |> 
  bake(new_data = education_train)
view(prep_rec) |>
  slice_head(n= 10)

# save recipe
save(education_recipe, file = here("results/education_recipe.rda"))

# only need separate recipe for rf if doing ns (natural spline); also naturally searches out interactions and work better w one hot encode


