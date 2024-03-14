## Basic repo setup for final project

*Engineering Success: Predicting Students’ Academic Dropout and Graduation Chances* aims to predict whether a student will remain enrolled at university after two semesters, whether they will drop out, or whether they will graduate based on a number of academic and personal characteristics. 

## Folders

- `data/`: can find raw data with codebook, split data, and resampling data (obtained using v-fold cross-validation)
- `scripts/`: can find scripts where work was completed
- `results/`: can find 12 models fit to the training data, the final fit on the boosted tree kitchen sink recipe, final accuracy results, the correlation plot used in the EDA, and the ROC comparison table used to determine the final winning model
- `memos/`: can find Progress Memo 1 and Progress Memo 2 QMD and html files
- `recipes/`: can find kitchen sink recipe (for tree and non-tree based models) and feature engineered recipe (for tree and non-tree based models)

## R Scripts

- `00_data_cleaning.R`: read in data, perform quality checks, and analysis of target variable
- `01_split_data.R`: split and fold data 
- `02a_recipe_kitchen_sink.R`: setup kitchen sink recipes
- `02b_recipe_trans.R`: setup feature engineered recipes
- `02c_visualizing_interact.R`: make correlation plot and visualize significance of interaction terms
- `02d_visualizing_transformations.R`: check for specific variable transformations
- `03a_fit_null.R`: define and fit null model to kitchen sink recipe
- `03a_fit_null_2.R`: define and fit null model to feature engineered recipe
- `03b_fit_multi.R`: define and fit multinomial model to kitchen sink recipe
- `03b_fit_multi_2.R`: define and fit multinomial model to feature engineered recipe
- `03c_fit_bt.R`: define and fit boosted tree to kitchen sink recipe
- `03c_fit_bt_2.R`: define and fit boosted tree model to feature engineered recipe
- `03d_fit_knn.R`: define and fit k-nearest neighbors model to kitchen sink recipe
- `03d_fit_knn_2.R`: define and fit k-nearest neighbors model to feature engineered recipe
- `03e_fit_rf.R`: define and fit random forest model to kitchen sink recipe
- `03e_fit_rf_2.R`: define and fit random forest model to feature engineered recipe
- `03f_fit_en.R`: define and fit elastic net model to kitchen sink recipe
- `03f_fit_en_2.R`: define and fit elastic net model to feature engineered recipe
- `04_model_analysis.R`: analysis of trained models by selecting best tuning parameters and selecting final model based on ROC AUC
- `05_train_final_model.R`: fitting final model (boosted tree kitchen sink)
- `06_assess_final_model.R`: assess final model (boosted tree kitchen sink) based on other metrics and a confusion matrix

## Reports
- `Son_Elizabeth_Final_Project.html`: html of final project
- `Son_Elizabeth_Final_Project.qmd`: qmd of final project
- `Son_Elizabeth_Executive_Summary.html`: html of executive summary
- `Son_Elizabeth_Executive_Summary.qmd`: qmd of executive summary
