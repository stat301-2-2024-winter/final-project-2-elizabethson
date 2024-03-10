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

# check interactions I used intuition for ---
# marital v. age
education_train |> 
  ggplot(aes(x = marital, y = age)) +
  geom_boxplot()

# debtor v. tuition_fees_up_to_date
education_train |> 
  ggplot(aes(fill = tuition_fees_up_to_date, x = debtor)) +
  geom_bar()

# admission_grade v. scholarship (no relationship detected)
education_train |> 
  ggplot(aes(x = admission_grade, y = scholarship)) +
  geom_boxplot()

# unemployment_rate v. debtor (no relationship detected)
education_train |> 
  ggplot(aes(x = debtor, y = unemployment_rate)) +
  geom_boxplot()

# displaced v. international
education_train |> 
  ggplot(aes(fill = international, x = displaced)) +
  geom_bar()
