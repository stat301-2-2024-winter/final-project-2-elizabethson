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
corplot <- ggcorrplot::ggcorrplot(cor_matrix) +
  ggtitle("Correlation Plot: Numerical Variables in Dataset")
save(corplot, file = here("results/corplot.rda"))

# check interactions I used intuition for ---
# marital v. age
education_train |> 
  ggplot(aes(x = marital, y = age)) +
  geom_boxplot() +
  labs(title = "Marital Status v. Age", 
       x = "Marital Status", 
       y = "Age")

# debtor v. tuition_fees_up_to_date
education_train |> 
  ggplot(aes(fill = tuition_fees_up_to_date, x = debtor)) +
  geom_bar() +
  labs(title = "Tuition Fees v. Debt", 
       x = "Debtor", 
       y = "Count", 
       fill = "Tuition Fees up to Date"
       )

# admission_grade v. scholarship (no relationship detected)
education_train |> 
  ggplot(aes(x = admission_grade, y = scholarship)) +
  geom_boxplot() +
  labs(title = "Admission Grade v. Scholarship Recipient", 
       x = "Admission Grade", 
       y = "Scholarship Recipient")

# unemployment_rate v. debtor (no relationship detected)
education_train |> 
  ggplot(aes(x = debtor, y = unemployment_rate)) +
  geom_boxplot() +
  labs(title = "Unemployment Rate v. Debt", 
       x = "Debtor", 
       y = "Unemployment Rate")

# displaced v. international
education_train |> 
  ggplot(aes(fill = international, x = displaced)) +
  geom_bar() +
  labs(title = "Displaced v. International Student", 
       x = "Displaced Student", 
       y = "Count", 
       fill = "International Student")

