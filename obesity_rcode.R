# LOAD LIBRARIES

library(naivebayes)
library(caret)
library(dplyr)
library(ggplot2)
library(shiny)
library(shinythemes)
library(rsconnect)

# LOAD THE DATASET

# Replace path if your file is stored somewhere else
data <- read.csv("D:\\obesity_project\\ObesityDataSet.csv")

# Check structure of dataset: types of columns, factor/numeric
str(data)

# Get summary of all columns
summary(data)

# Check number of missing values in each column
colSums(is.na(data))

# DATA PREPROCESSING
# Convert character columns into factors (important for Naive Bayes)

data <- data %>% mutate_if(is.character, as.factor)


# Verify structure again after conversion
str(data)


# EXPLORATORY DATA ANALYSIS 

# 1. Distribution of Obesity Levels
ggplot(data, aes(x = NObeyesdad, fill = NObeyesdad)) +
  geom_bar() +
  theme_minimal() +
  labs(title = "Obesity Level Distribution",
       x = "Obesity Class",
       y = "Count")


# 2. Gender vs Obesity Level
ggplot(data, aes(x = Gender, fill = NObeyesdad)) +
  geom_bar(position = "dodge") +
  theme_minimal() +
  labs(title = "Gender-wise Obesity Levels",
       x = "Gender",
       y = "Count")


# SPLIT DATA INTO TRAINING & TEST SET (80/20)
# Using stratified sampling to maintain class balance

set.seed(123)  # for reproducibility
index <- createDataPartition(data$NObeyesdad, p = 0.8, list = FALSE)

train <- data[index, ]   # 80% training data
test  <- data[-index, ]  # 20% testing data


# TRAIN NAIVE BAYES MODEL

model <- naive_bayes(NObeyesdad ~ ., data = train)

# View model details
print(model)

# MAKE PREDICTIONS ON TEST DATA

pred <- predict(model, newdata = test)

# MODEL EVALUATION USING CONFUSION MATRIX

conf_mat <- confusionMatrix(pred, test$NObeyesdad)
print(conf_mat)

# Print Accuracy %
cat("Model Accuracy: ", round(conf_mat$overall['Accuracy'] * 100, 2), "%\n")


# VISUALIZE CONFUSION MATRIX (HEATMAP)

cm_df <- as.data.frame(conf_mat$table)

ggplot(cm_df, aes(Prediction, Reference, fill = Freq)) +
  geom_tile() +
  geom_text(aes(label = Freq), color = "white", size = 4) +
  scale_fill_gradient(low = "skyblue", high = "blue") +
  theme_minimal() +
  labs(title = "Confusion Matrix Heatmap",
       x = "Predicted Class",
       y = "Actual Class")

#Save model
saveRDS(model, "obesity_model.rds")



