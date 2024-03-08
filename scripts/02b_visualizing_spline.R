# Progress Memo 2.2 R Script
# check for relationships between predictor and target vars ---

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data ---
load(here("data/education_folds.rda"))
load(here("data/education_split.rda"))

# relationship plots for categorical variables ---
create_bar_plot <- function(data, x_var) {
  data |> 
    ggplot(aes(x = target, fill = !!sym(x_var))) +
    geom_bar(position = "fill") +
    labs(title = paste("Bar Plot of Target against", x_var),
         x = "Target",
         y = "Proportion") +
    theme_minimal()
}

categorical_names <- education_train |> 
  select(where(is.factor)) |> 
  colnames()

for (var in categorical_names) {
  print(create_bar_plot(education_train, var))
}

# relationship plots for numerical variables ---
create_histogram <- function(data, numerical_var) {
  data |> 
    ggplot(aes(x = !!sym(numerical_var), fill = target)) +
    geom_histogram() +
    labs(title = paste("Histogram of", numerical_var, "against Target"),
         x = numerical_var,
         y = "Count",
         color = "Target") +
    facet_wrap(~target) +
    theme_minimal()
}

numerical_names <- education_train |> 
  select(where(is.numeric)) |> 
  colnames()

for (var in numerical_names) {
  print(create_histogram(education_train, var))
}
