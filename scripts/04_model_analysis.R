# Analysis of all 12 models (comparisons)

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# parallel processing ---
library(doMC)
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)

# load data ---
load(here("data/education_folds.rda"))
load(here("data/education_split.rda"))

# load model fits ---
load(here("results/null_fit.rda"))
load(here("results/mn_fit.rda"))
load(here("results/bt_fit.rda"))
load(here("results/knn_fit.rda"))
load(here("results/rf_fit.rda"))
load(here("results/en_fit.rda"))
load(here("results/null_fit_2.rda"))
load(here("results/mn_fit_2.rda"))
load(here("results/bt_fit_2.rda"))
load(here("results/knn_fit_2.rda"))
load(here("results/rf_fit_2.rda"))
load(here("results/en_fit_2.rda"))

# pick best ROC
null_fit_best <- show_best(null_fit, metric = "roc_auc")[1,]
mn_tuned_best <- show_best(mn_fit, metric = "roc_auc")[1,]
bt_tuned_best <- show_best(bt_fit, metric = "roc_auc")[1,]
knn_tuned_best <- show_best(knn_fit, metric = "roc_auc")[1,]
rf_tuned_best <- show_best(rf_fit, metric = "roc_auc")[1,]
en_tuned_best <- show_best(en_fit, metric = "roc_auc")[1,]
null_fit_best_2 <- show_best(null_fit_2, metric = "roc_auc")[1,]
mn_tuned_best_2 <- show_best(mn_fit_2, metric = "roc_auc")[1,]
bt_tuned_best_2 <- show_best(bt_fit_2, metric = "roc_auc")[1,]
knn_tuned_best_2 <- show_best(knn_fit_2, metric = "roc_auc")[1,]
rf_tuned_best_2 <- show_best(rf_fit_2, metric = "roc_auc")[1,]
en_tuned_best_2 <- show_best(en_fit_2, metric = "roc_auc")[1,]

# bind rows
education_metrics <- bind_rows(null_fit_best |> mutate(model = "Null"),
                               mn_tuned_best |> mutate(model = "Multinomial"),
                               bt_tuned_best |> mutate(model = "Boosted Tree"),
                               knn_tuned_best |> mutate(model = "K-Nearest Neighbors"),
                               rf_tuned_best |> mutate(model = "Random Forest"),
                               en_tuned_best |> mutate(model = "Elastic Net"),
                               null_fit_best_2 |> mutate(model = "Null"),
                               mn_tuned_best_2 |> mutate(model = "Multinomial"),
                               bt_tuned_best_2 |> mutate(model = "Boosted Tree"),
                               knn_tuned_best_2 |> mutate(model = "K-Nearest Neighbors"),
                               rf_tuned_best_2 |> mutate(model = "Random Forest"),
                               en_tuned_best_2 |> mutate(model = "Elastic Net")) |> 
  mutate(recipe = c("Kitchen Sink", "Kitchen Sink", "Kitchen Sink",
                    "Kitchen Sink", "Kitchen Sink", "Kitchen Sink",
                    "Pre-Processed", "Pre-Processed",
                    "Pre-Processed", "Pre-Processed",
                    "Pre-Processed", "Pre-Processed"))

# build ROC table
roc_table <- education_metrics |>
  select("Model" = model, 
         "ROC" = mean,
         "Computations" = n,
         "SE" = std_err,
         "Recipe" = recipe) |> 
  knitr::kable(digits = c(NA, 2, 3, 0))

# show ROC table
roc_table

# save ROC table
save(roc_table, file = here("results/roc_table.rda"))
