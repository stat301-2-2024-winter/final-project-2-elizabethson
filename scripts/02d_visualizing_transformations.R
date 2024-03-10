# check for specific var transformations ---

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data ---
load(here("data/education_folds.rda"))
load(here("data/education_split.rda"))
load(here("data/education.rda"))

# create density plots ---
create_density <- function(data, numerical_var){
  data |> 
    ggplot(aes(x = !!sym(numerical_var))) +
    geom_density() +
    labs(title = paste("Density Plot of", numerical_var),
         x = numerical_var) +
    theme_minimal()
}

numerical_names <- education_train |> 
  select(where(is.numeric)) |> 
  colnames()

for (var in numerical_names) {
  print(create_density(education_train, var))
}

# check for step_other using barplots on categorical variables ---
education_train |>
  ggplot(aes(y = marital)) +
  geom_bar()

education_train |>
  ggplot(aes(y = application_order)) +
  geom_bar()
