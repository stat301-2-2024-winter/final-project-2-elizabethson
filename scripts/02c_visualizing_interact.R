# Progress Memo 2.2 R Script
# check for interaction terms ---

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data ---
load(here("data/education_folds.rda"))
load(here("data/education_split.rda"))

# make corrplot ---
# select numerical variables
numerical_data <- education_train |> 
  select(where(is.numeric))

cor_matrix <- cor(numerical_data)

# get variable names for plotting
numerical_names <- colnames(numerical_data)

# create corplot
ggcorrplot::ggcorrplot(cor_matrix) +
  ggtitle("Correlation Plot: Numerical Variables in Dataset")
