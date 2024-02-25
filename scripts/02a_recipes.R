# Progress Memo 2.2 R Script
# set up pre-processing/recipes ---

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data ---
load(here("data/education_folds.rda"))

# recipe for lm, ridge, lasso, knn ---
# see 3.4.2 and 4.1.3, 4.2.3
# how to know which to interact?
# do i have to graph each relationship? --> write a function plotting each numeric var (like a hist) to quickly flip thru
# should i step normalize all? 
# dummy only the factors? 
# WHAT IS A BSELINE?NULL MODEL

# create recipe (1 kitchen sink with everything and 1 with transformations: interaction, dummy, normalization, nat spline, other transformations, being selective w variables)
kc_recipe <- recipe(log_price ~ ., data = kc_train) |> 
  step_log(sqft_living, sqft_lot, sqft_above, sqft_living15, sqft_lot15, base = 10) |> 
  step_mutate(sqft_basement = ifelse(sqft_basement > 0, 1, 0)) |> 
  step_ns(lat, deg_free = 5) |> 
  step_normalize(all_predictors()) |> 
  step_zv(all_predictors())

# check recipe
prep_rec <- prep(kc_recipe) |> 
  bake(new_data = kc_train)
view(prep_rec) |>
  slice_head(n= 10)

# save recipe
save(kc_recipe, file = here("results/kc_recipe.rda"))

# recipe for rf ---
# create rf recipe
kc_rf_recipe <- recipe(log_price ~ ., data = kc_train) |>
  step_rm(id, date, zipcode, price) |> 
  step_log(sqft_living, sqft_lot, sqft_above, sqft_living15, sqft_lot15, base = 10) |> 
  step_mutate(sqft_basement = ifelse(sqft_basement > 0, 1, 0)) |> 
  step_normalize(all_predictors()) |> 
  step_zv(all_predictors())

# check recipe
prep_rec <- prep(kc_rf_recipe) |> 
  bake(new_data = kc_train)
view(prep_rec) |>
  slice_head(n= 10)

# save recipe
save(kc_rf_recipe, file = here("results/kc_rf_recipe.rda"))
