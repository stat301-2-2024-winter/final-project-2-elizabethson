# assess final model ---

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data ---
load(here("data/education_folds.rda"))
load(here("data/education_split.rda"))

# load best model and fit ---
load(here("results/bt_fit.rda"))
load(here("results/final_fit.rda"))

# bind cols together ---
education_result <- education_test |> 
  select(target) |>
  bind_cols(predict(final_fit, education_test, type = "class")) |> 
  bind_cols(predict(final_fit, education_test, type = "prob"))
# check
education_result |> 
  slice_head(n = 5)

# conf matrix ---
education_result |> 
  conf_mat(target, .pred_class) |> 
  autoplot(type = "heatmap")

# accuracy ---
predict_accuracy <- accuracy(education_result, target, .pred_class)

# metric set ---
eval_metrics <- metric_set(ppv, recall, accuracy, f_meas)
metric_set <- eval_metrics(data = education_result, truth = target, estimate = .pred_class)

# ROC AUC ---
# table
education_result |> 
  roc_auc(target, c(.pred_Dropout, .pred_Enrolled, .pred_Graduate))
# plot
education_result |> 
  roc_curve(target, c(.pred_Dropout, .pred_Enrolled, .pred_Graduate)) |> 
  ggplot(aes(x = 1 - specificity, y = sensitivity, color = .level)) +
  geom_abline(lty = 2, color = "gray80", size = 0.9) +
  geom_path(show.legend = T, alpha = 0.6, size = 1.2) +
  theme_minimal() +
  coord_equal()

# save ---
save(titanic_conf_mat, final_predict, final_accuracy, file = here("exercise_2/results/final_accuracy_results.rda"))
