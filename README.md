# 🧠 Obesity Level Predictor using R & Shiny

This project is a **Machine Learning-based web application** that predicts an individual's **obesity level** using lifestyle habits, physical activity, and demographic information. The application is built in **R** using the **Shiny** framework and deployed on **shinyapps.io** for easy web access.

---

## 🌐 Live Application

🔗 **Try It Online:** https://hasitha.shinyapps.io/obesity_project/

You can interact with the model by entering your details and instantly viewing the predicted obesity category along with lifestyle suggestions.

---

## 🚀 Key Features

✔️ Predicts obesity level in real-time  
✔️ Uses **Naive Bayes classifier** for lightweight and efficient prediction  
✔️ Provides explanations and recommendations based on predicted class  
✔️ Displays probability scores for all obesity levels  
✔️ Enhanced user interface with modern theme and styled components  
✔️ Fully reproducible — dataset and model included

---

## 📦 Required Packages

Install these packages **once** before running the application:

```R
install.packages(c(
  "naivebayes",
  "caret",
  "dplyr",
  "ggplot2",
  "shiny",
  "shinythemes"
))
```
Load them in r
```R
library(naivebayes)
library(caret)
library(dplyr)
library(ggplot2)
library(shiny)
library(shinythemes)
```

---

## ▶️ Run Application Locally

1.  **Clone** or **download** the project files.
2.  Open RStudio and set the project directory as your working directory.
3.  Ensure you have the required R libraries installed: `naivebayes`, `caret`, `dplyr`, `ggplot2`, `shiny`, and `shinythemes`.
4.  Execute the following command in your R console:

```R
shiny::runApp()
# This will launch the UI in your browser.
```
---

## 🗂️ Project Structure

| File/Folder | Description |
| :--- | :--- |
| `app.R` | **Shiny web application** - Contains the UI and server logic for the prediction interface. |
| `obesity_model.rds` | **Saved ML model** - The pre-trained Naive Bayes classifier. |
| `ObesityDataSet.csv` | **Training dataset** - Used for model development. |
| `obesity_rcode.R` | **Model training script** - Contains the preprocessing and Naive Bayes training code. |

---
## 📊 Dataset Overview: `ObesityDataSet.csv`

The dataset used in this project contains **2,111 observations** and **17 attributes** related to demographic, dietary, and lifestyle habits. These features are used to classify individuals into one of seven distinct obesity categories.

---

### 📌 Key Attributes

| Feature | Description | Example Values / Type |
| :--- | :--- | :--- |
| **Gender** | Biological sex of the individual | Male/Female |
| **Age** | Age of the person in years | Numerical |
| **Height** | Height in meters | Numerical |
| **Weight** | Weight in kilograms | Numerical |
| **family_history_with_overweight** | Whether close relatives have obesity | yes/no |
| **FAVC** | Frequent consumption of high-caloric food | yes/no |
| **FCVC** | Frequency of vegetable consumption (1=Never, 3=Always) | 1–3 |
| **NCP** | Number of main meals per day | Numerical |
| **CAEC** | Eating between meals | Always / Frequently / Sometimes / No |
| **SMOKE** | Smoking habit | yes/no |
| **CH2O** | Water consumption per day (in liters) | Numerical |
| **SCC** | Calorie consumption monitoring | yes/no |
| **FAF** | Weekly physical activity frequency (0–3) | Numerical |
| **TUE** | Daily time spent using technology devices (0–2) | Numerical |
| **CALC** | Alcohol consumption frequency | No / Sometimes / Frequently / Always |
| **MTRANS** | Primary mode of transportation | Public_Transportation, Automobile, etc. |
| **NObeyesdad** | **Target variable** — Obesity classification label | Categorical (7 classes) |

---

### 🎯 Target Classes (`NObeyesdad`)

The target variable defines the following progressive levels of weight status and associated health risks:

* **Insufficient_Weight**
* **Normal_Weight**
* **Overweight_Level_I**
* **Overweight_Level_II**
* **Obesity_Type_I**
* **Obesity_Type_II**
* **Obesity_Type_III**

---

### 📌 Why This Dataset?

This dataset is ideal for obesity prediction because:

✔️ It includes both **numeric and categorical features**, making it robust for real-world modeling.
✔️ Represents **real-world lifestyle behaviors** critical for health assessment.
✔️ Supports the required **multi-class classification**.
✔️ Enables **interpretable predictions** using the Naive Bayes algorithm.

---

## 🧠 Machine Learning Model Used — Naive Bayes Classifier

### 🔍 What is Naive Bayes?

The Naive Bayes classifier is a **probabilistic machine learning algorithm** based on **Bayes' Theorem**, which calculates the likelihood of different classes based on the given features.

It is called **"naive"** because it assumes that all features are independent of each other—a simplification that provides significant benefits:

* Extremely **fast** and **easy** to implement.
* **Effective** even with small datasets.
* Capable of handling both **categorical and numeric features**.

### 🎯 Why Naive Bayes for This Project?

✔️ Works well with **lifestyle and behavioral datasets** typical in health prediction.
✔️ Handles **multi-class output** efficiently (7 obesity levels).
✔️ Produces **interpretable class probabilities**, aiding user understanding.
✔️ Requires **minimal training time** and memory usage.
✔️ Proven to be **accurate** for structured health-related datasets.

---

## 🏁 Conclusion

This project successfully integrates **Machine Learning** and **Interactive Web Development in R** to create a real-time obesity level prediction system. It not only classifies the user's obesity category but also guides them with meaningful health insights and actionable information.

---

## 👤 Author

**Hasitha**

*Machine Learning Project — Obesity Level Predictor.*
