# training the final model ---

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data ---
# SEE SLIDE 8
set.seed(123)
final_fit <- fit(multinom_wkflow, data = education_train)

education_metrics1 <- metric_set(roc_auc)
education_metrics2 <- metric_set(f_meas, accuracy)

education_results <- education_test |> 
  select(target) |> 
  bind_cols(predict(final_fit, new_data = education_test),
            predict(final_fit, new_data = education_test, type = "prob"))

education_results |> 
  # in multiclass prediction must provide all "pred" columns for roc_auc
  education_metrics1(truth = target, .pred_Adelie:.pred_Gentoo)