# Progress Memo 2.2 R Script
# training the final model ---

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data ---
# SEE SLIDE 8

final_fit <- fit(multinom_wkflow, data = penguins_train)

penguins_metrics1 <- metric_set(roc_auc)
penguins_metrics2 <- metric_set(f_meas, accuracy)

penguins_results <- penguins_test |> 
  select(species) |> 
  bind_cols(predict(final_fit, new_data = penguins_test),
            predict(final_fit, new_data = penguins_test, type = "prob"))

penguins_results |> 
  # in multiclass prediction must provide all "pred" columns for roc_auc
  penguins_metrics1(truth = species, .pred_Adelie:.pred_Gentoo)

# conf matrix
penguins_results |> 
  conf_mat(species, .pred_class) |> 
  autoplot(type = "heatmap")