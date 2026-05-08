# =============================================================================
# OBESITY LEVEL PREDICTION USING NAIVE BAYES
# =============================================================================

# =============================================================================
# 1. INSTALL & LOAD LIBRARIES
# =============================================================================
required_packages <- c(
  "tidyverse", "caret", "e1071", "ggplot2"
)

for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  }
}
install.packages("shiny")
install.packages("rsconnect")
set.seed(42)

# =============================================================================
# 2. LOAD DATASET
# =============================================================================
cat("Loading dataset...\n")

df <- read.csv(
  "D:\\obesity_prediction\\ObesityDataSet_raw_and_data_sinthetic.csv",
  stringsAsFactors = FALSE
)

cat("Dataset dimensions:", dim(df), "\n")

# =============================================================================
# 3. PREPROCESSING
# =============================================================================
cat("\n--- PREPROCESSING ---\n")

names(df)[names(df) == "NObeyesdad"] <- "ObesityLevel"

df$Gender <- ifelse(df$Gender == "Male", 1, 0)
df$family_history_with_overweight <- ifelse(df$family_history_with_overweight == "yes", 1, 0)
df$FAVC <- ifelse(df$FAVC == "yes", 1, 0)
df$SMOKE <- ifelse(df$SMOKE == "yes", 1, 0)
df$SCC <- ifelse(df$SCC == "yes", 1, 0)

df$CAEC <- as.integer(factor(df$CAEC,
                             levels = c("no", "Sometimes", "Frequently", "Always"))) - 1

df$CALC <- as.integer(factor(df$CALC,
                             levels = c("no", "Sometimes", "Frequently", "Always"))) - 1

df$MTRANS <- as.integer(factor(df$MTRANS,
                               levels = c("Walking", "Bike", "Motorbike",
                                          "Public_Transportation", "Automobile")))

# BMI feature
df$BMI <- df$Weight / (df$Height ^ 2)

# Convert target to factor
df$ObesityLevel <- factor(make.names(df$ObesityLevel))

cat("Classes:\n")
print(levels(df$ObesityLevel))

# =============================================================================
# 4. TRAIN / TEST SPLIT
# =============================================================================
set.seed(42)

train_idx <- createDataPartition(df$ObesityLevel,
                                 p = 0.80,
                                 list = FALSE)

train_data <- df[train_idx, ]
test_data  <- df[-train_idx, ]

cat("\nTrain rows:", nrow(train_data), "\n")
cat("Test rows :", nrow(test_data), "\n")

# =============================================================================
# 5. TRAIN NAIVE BAYES MODEL
# =============================================================================
cat("\n--- TRAINING NAIVE BAYES ---\n")

nb_model <- naiveBayes(ObesityLevel ~ ., data = train_data)

cat("Naive Bayes model trained successfully.\n")

# =============================================================================
# 6. PREDICTIONS
# =============================================================================
nb_preds <- predict(nb_model, newdata = test_data)

# =============================================================================
# 7. EVALUATION
# =============================================================================
cat("\n--- MODEL EVALUATION ---\n")

cm <- confusionMatrix(nb_preds, test_data$ObesityLevel)

cat("Accuracy :", round(cm$overall["Accuracy"], 4), "\n")
cat("Kappa    :", round(cm$overall["Kappa"], 4), "\n")

print(cm)

# =============================================================================
# 8. CONFUSION MATRIX HEATMAP
# =============================================================================
cm_df <- as.data.frame(cm$table)

ggplot(cm_df, aes(x = Reference, y = Prediction, fill = Freq)) +
  geom_tile(color = "white") +
  geom_text(aes(label = Freq), size = 4) +
  theme_minimal() +
  labs(title = "Naive Bayes Confusion Matrix",
       x = "Actual",
       y = "Predicted")

# =============================================================================
# 9. SAVE MODEL
# =============================================================================
saveRDS(nb_model, "obesity_naive_bayes_model.rds")

cat("\nModel saved successfully.\n")

# =============================================================================
# 10. EXAMPLE PREDICTION
# =============================================================================
new_patient <- data.frame(
  Gender = 1,
  Age = 28,
  Height = 1.75,
  Weight = 95,
  family_history_with_overweight = 1,
  FAVC = 1,
  FCVC = 2,
  NCP = 3,
  CAEC = 1,
  SMOKE = 0,
  CH2O = 2,
  SCC = 0,
  FAF = 1,
  TUE = 1,
  CALC = 1,
  MTRANS = 4,
  BMI = 95 / (1.75^2)
)

prediction <- predict(nb_model, newdata = new_patient)

cat("\nPredicted Obesity Level:\n")
print(prediction)

cat("\n✅ DONE - Naive Bayes Model Ready.\n")
# Save model to specific location

