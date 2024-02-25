# Progress Memo 1 R Script
# read in data, perform quality checks, and analysis of target variable ---

# load packages
library(readr)
library(tidyverse)
library(janitor)
library(here)

# read in data
education <- read.csv(file = "data/data.csv", sep = ';') |> 
  clean_names() |> 
  rename("marital" = "marital_status",
         "attendance_mode" = "daytime_evening_attendance",
         "previous_qual" = "previous_qualification",
         "previous_qual_grade" = "previous_qualification_grade",
         "nationality" = "nacionality",
         "mother_qual" = "mother_s_qualification",
         "father_qual" = "father_s_qualification",
         "mother_occu" = "mother_s_occupation",
         "father_occu" = "father_s_occupation",
         "scholarship" = "scholarship_holder",
         "special_needs" = "educational_special_needs",
         "age" = "age_at_enrollment",
         "1st_sem_credited" = "curricular_units_1st_sem_credited",
         "1st_sem_enrolled" = "curricular_units_1st_sem_enrolled",
         "1st_sem_eval" = "curricular_units_1st_sem_evaluations",
         "1st_sem_approved" = "curricular_units_1st_sem_approved",
         "1st_sem_grade" = "curricular_units_1st_sem_grade",
         "1st_sem_wo_eval" = "curricular_units_1st_sem_without_evaluations",
         "2nd_sem_credited" = "curricular_units_2nd_sem_credited",
         "2nd_sem_enrolled" = "curricular_units_2nd_sem_enrolled",
         "2nd_sem_eval" = "curricular_units_2nd_sem_evaluations",
         "2nd_sem_approved" = "curricular_units_2nd_sem_approved",
         "2nd_sem_grade" = "curricular_units_2nd_sem_grade",
         "2nd_sem_wo_eval" = "curricular_units_2nd_sem_without_evaluations"
         ) |> 
  mutate(marital = factor(marital),
         application_order = factor(application_order),
         attendance_mode = factor(attendance_mode),
         displaced = factor(displaced),
         special_needs = factor(special_needs),
         debtor = factor(debtor),
         tuition_fees_up_to_date = factor(tuition_fees_up_to_date),
         gender = factor(gender),
         scholarship = factor(scholarship),
         international = factor(international),
         target = factor(target)
         )

# save
save(education, file = "data/education.rda")

# read
load(here("data/education.rda"))

# quality check --- 
# number of variables
ncol(education)
# number of observations
nrow(education)
# categorical v numerical variables

# missingness issues
skimr::skim_without_charts(education)
skimr::skim(education)

# potential data issues ---
education |> ggplot() +
  geom_bar(aes(x = target)) +
  labs(title = "Counts of Target Variable Categories",
       x = "Student Result",
       y = NULL)

sum(is.na(education$target))

# EDA ---
corr <- education |> 
  select(where(is.numeric)) |> 
  cor()
ggcorrplot::ggcorrplot(corr)

