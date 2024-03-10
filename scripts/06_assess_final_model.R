# Progress Memo 2.2 R Script
# assess final model ---

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data ---


# conf matrix
penguins_results |> 
  conf_mat(species, .pred_class) |> 
  autoplot(type = "heatmap")