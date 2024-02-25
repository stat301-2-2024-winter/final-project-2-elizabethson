# Progress Memo 2.1 R Script
# split and check data (inc. V fold cross validation) ---

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data ---
load(here("data/education.rda"))

# split data ---
# set seed
set.seed(123)
# split data
education_split <- education |> 
  initial_split(prop = 0.8, strata = target)
# train data
education_train <- training(education_split)
# test data
education_test <- testing(education_split)

# check splits ---
# columns
ncol(education)
ncol(education_train)
ncol(education_test)
# rows
nrow(education) * 0.8
nrow(education_train)
nrow(education) * 0.2
nrow(education_test)

# saving
save(education_train, education_test, file = "data/education_split.rda")

# v-fold cross validation ---
# set seed
set.seed(123)
# v-fold
education_folds <- vfold_cv(education_train, v = 10, repeats = 3,
                     strata = target)
# saving
save(education_folds, file = here("data/education_folds.rda"))
