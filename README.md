# AI-Powered Obesity Level Prediction System

An interactive Machine Learning web application built using **R**, **Shiny**, and **Naive Bayes** that predicts obesity levels based on lifestyle habits, eating patterns, and physical activity.

The system provides:
- Real-time obesity level prediction
- BMI calculation
- Personalized health suggestions
- Interactive dashboard interface
- Cloud deployment using ShinyApps.io

---

# Live Demo

🚀 Live Application:

https://hasitha.shinyapps.io/obesity_prediction/

---

# Project Importance

Obesity is one of the major global health concerns associated with:
- Poor eating habits
- Sedentary lifestyle
- Lack of physical activity
- High-calorie food consumption

Early prediction of obesity levels can help individuals:
- Improve lifestyle habits
- Monitor health risks
- Follow preventive healthcare measures
- Reduce long-term medical complications

This project demonstrates how Machine Learning can be applied in healthcare analytics to provide quick and intelligent health assessments.

---

# Features

- Modern and responsive Shiny UI
- Machine Learning-based prediction system
- BMI calculation
- Personalized health recommendations
- Real-time prediction results
- Interactive dashboard
- Lightweight and fast model
- Fully deployed online

---

# Tech Stack

| Technology | Purpose |
|------------|----------|
| R | Core programming language |
| Shiny | Interactive web application framework |
| Naive Bayes | Machine Learning algorithm |
| e1071 | Naive Bayes implementation |
| caret | Data preprocessing & evaluation |
| shinythemes | UI styling |
| shinyapps.io | Cloud deployment |

---

# Machine Learning Workflow

## Dataset
The project uses an obesity prediction dataset containing:
- Physical attributes
- Lifestyle information
- Eating habits
- Activity patterns

---

## Data Preprocessing

The following preprocessing steps were performed:
- Handling categorical variables
- Feature encoding
- BMI feature engineering
- Data cleaning
- Train-test splitting

---

# Why Naive Bayes?

Naive Bayes was selected because:

- It performs efficiently on multi-class classification problems
- It is computationally lightweight and fast
- It works well with healthcare and categorical datasets
- It handles probabilistic predictions effectively
- It requires less training time compared to complex models

For this project, Naive Bayes provided strong performance while keeping the system simple, efficient, and suitable for real-time prediction.

---

# Model Performance

| Metric | Value |
|--------|--------|
| Algorithm | Naive Bayes |
| Task Type | Multi-class Classification |
| Accuracy | 86% |

The model achieved **86% classification accuracy**, demonstrating reliable prediction capability for obesity level classification.

---

# Prediction Categories

The model predicts the following obesity levels:

- Insufficient Weight
- Normal Weight
- Overweight Level I
- Overweight Level II
- Obesity Type I
- Obesity Type II
- Obesity Type III

---

# Application Inputs

The user provides:
- Gender
- Age
- Height
- Weight
- Water intake
- Physical activity level
- Family history of overweight
- High calorie food consumption

---

# Personalized Suggestions

Based on prediction results, the application generates:
- Dietary recommendations
- Exercise suggestions
- Lifestyle improvement tips
- Weight management guidance

---

# Project Structure

```text
obesity-level-prediction/
│
├── app.R
├── obesity_naive_bayes_model.rds
├── README.md
├── .gitignore
```

---

# Installation & Local Setup

## Clone Repository

```bash
git clone https://github.com/YOUR_USERNAME/obesity-level-prediction.git
cd obesity-level-prediction
```

---

## Install Required Packages

```r
install.packages(c(
  "shiny",
  "shinythemes",
  "e1071",
  "caret",
  "tidyverse",
  "rsconnect"
))
```

---

## Run the Application

```r
shiny::runApp()
```

---

# Deployment

The application is deployed using:
- shinyapps.io
- rsconnect

---


# Learning Outcomes

This project helped in understanding:
- Machine Learning workflows in R
- Data preprocessing techniques
- Feature engineering
- Model deployment
- Interactive Shiny dashboard development
- Healthcare analytics applications
- UI/UX design for AI applications

---

# Author

## Hasitha

---
