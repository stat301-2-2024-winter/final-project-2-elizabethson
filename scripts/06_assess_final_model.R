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
education_conf_matrix <- education_result |> 
  conf_mat(target, .pred_class) |> 
  autoplot(type = "heatmap")

# metric set ---
eval_metrics <- metric_set(recall, accuracy)
metric_set <- eval_metrics(data = education_result, truth = target, estimate = .pred_class) |> 
  select("Metric" = .metric, 
         "Estimate" = .estimate) |> 
  knitr::kable()

# ROC AUC ---
# table
roc_table <- education_result |> 
  roc_auc(target, c(.pred_Dropout, .pred_Enrolled, .pred_Graduate)) |> 
  select("Metric" = .metric, 
         "Estimate" = .estimate) |> 
  knitr::kable()

# plot
roc_plot <- education_result |> 
  roc_curve(target, c(.pred_Dropout, .pred_Enrolled, .pred_Graduate)) |> 
  ggplot(aes(x = 1 - specificity, y = sensitivity, color = .level)) +
  geom_abline(lty = 2, color = "gray80", size = 0.9) +
  geom_path(show.legend = T, alpha = 0.6, size = 1.2) +
  theme_minimal() +
  coord_equal() +
  labs(title = "ROC Curve", color = "Target", 
       y = "Sensitivity", 
       x = "1 - Specificity")

# save ---
save(education_conf_matrix, metric_set, roc_table, roc_plot, file = here("results/final_accuracy_results.rda"))
