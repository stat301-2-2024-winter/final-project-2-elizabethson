# set up transformed recipe ---

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data ---
load(here("data/education_folds.rda"))
load(here("data/education_split.rda"))

# transformed recipe ---
education_recipe_trans <- recipe(target ~ ., data = education_train) |> 
  step_rm(mother_occu) |> 
  step_interact(terms = ~ marital:age) |> 
  step_interact(terms = ~ displaced:international) |> 
  step_interact(terms = ~ debtor:tuition_fees_up_to_date) |> 
  step_dummy(all_nominal_predictors()) |> 
  step_interact(terms = ~ mother_qual:father_qual) |> 
  step_interact(terms = ~ gdp:unemployment_rate) |> 
  step_interact(terms = ~ `1st_sem_enrolled`:`2nd_sem_enrolled`) |> 
  step_interact(terms = ~ `1st_sem_credited`:`2nd_sem_credited`) |> 
  step_interact(terms = ~ `1st_sem_enrolled`:`1st_sem_credited`) |> 
  step_interact(terms = ~ `2nd_sem_enrolled`:`2nd_sem_credited`) |>
  step_interact(terms = ~ `1st_sem_grade`:`2nd_sem_grade`) |> 
  step_BoxCox(age) |> 
  step_corr(all_predictors()) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_predictors())

# check recipe
prep_rec <- prep(education_recipe_trans) |> 
  bake(new_data = education_train)
view(prep_rec) |>
  slice_head(n= 10) # 69 predictors

# save recipe
save(education_recipe_trans, file = here("results/education_recipe_trans.rda"))

# transformed recipe for tree models ---
education_recipe_trans_tree <- recipe(target ~ ., data = education_train) |> 
  step_rm(mother_occu) |>
  step_impute_mean(all_numeric_predictors()) |> 
  step_impute_mode(all_nominal_predictors()) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_BoxCox(age) |> 
  step_corr(all_predictors()) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_predictors())

# check recipe
prep_rec <- prep(education_recipe_trans_tree) |> 
  bake(new_data = education_train)
view(prep_rec) |>
  slice_head(n= 10) # 55 predictors

# save recipe
save(education_recipe_trans_tree, file = here("results/education_recipe_trans_tree.rda"))
