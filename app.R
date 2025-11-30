# app.R  ---- Obesity Level Predictor (Naive Bayes + Shiny)

library(shiny)
library(shinythemes)
library(naivebayes)
library(dplyr)

# ---------------------------------------------------------
# LOAD DATA & MODEL
# ---------------------------------------------------------
# Make sure these files are in the same folder as app.R
data  <- read.csv("ObesityDataSet.csv")
data  <- data %>% mutate_if(is.character, as.factor)

model <- readRDS("obesity_model.rds")   # keep this name if your .rds is saved like this

# ---------------------------------------------------------
# CLASS DESCRIPTIONS & TIPS
# ---------------------------------------------------------
class_descriptions <- c(
  "Insufficient_Weight" = "Your weight is below the healthy range for your height. This may be related to undernutrition, high metabolism, or other health factors.",
  "Normal_Weight"       = "Your weight is within the generally healthy range for your height. Keep maintaining a balanced lifestyle.",
  "Overweight_Level_I"  = "You are slightly above the recommended weight range. This can increase your risk of future health problems if not managed.",
  "Overweight_Level_II" = "You are moderately above the recommended weight range. The risk for metabolic diseases (like diabetes and hypertension) is higher.",
  "Obesity_Type_I"      = "This is Obesity Class I. There is a significant increase in health risks, including cardiovascular disease and diabetes.",
  "Obesity_Type_II"     = "This is Obesity Class II. Health risks are high, and medical guidance is strongly recommended.",
  "Obesity_Type_III"    = "This is Obesity Class III (severe obesity). There is a very high risk of serious health complications; professional medical support is very important."
)

class_tips <- c(
  "Insufficient_Weight" = "Focus on nutrient-dense foods, regular meals, and consider consulting a nutritionist if weight gain is difficult.",
  "Normal_Weight"       = "Maintain regular physical activity, balanced diet, good sleep, and periodic health check-ups.",
  "Overweight_Level_I"  = "Try to increase daily activity (walking, light exercise) and reduce sugary drinks and ultra-processed foods.",
  "Overweight_Level_II" = "Structured exercise, portion control, and reducing high-calorie snacks can help. A dietitian can give a personalized plan.",
  "Obesity_Type_I"      = "Combine medical advice with lifestyle changes: regular exercise, monitored diet, and tracking health indicators like BP and blood sugar.",
  "Obesity_Type_II"     = "Work with healthcare professionals to create a long-term weight management plan and screen for existing health conditions.",
  "Obesity_Type_III"    = "Seek medical supervision. A multidisciplinary approach (doctor, dietitian, sometimes psychologist) is often needed for safe progress."
)

# ---------------------------------------------------------
# UI
# ---------------------------------------------------------
ui <- fluidPage(
  theme = shinytheme("flatly"),

  tags$head(
    tags$style(HTML("
      body {
        background: linear-gradient(135deg, #e3f2fd, #f8f9ff);
      }
      .app-title {
        font-weight: 700;
        margin-bottom: 5px;
      }
      .subtitle {
        color: #555555;
        margin-bottom: 20px;
      }
      .card {
        background-color: #ffffff;
        border-radius: 14px;
        padding: 15px 20px;
        box-shadow: 0 4px 10px rgba(0,0,0,0.06);
        margin-bottom: 15px;
      }
      .card-header {
        border-bottom: 1px solid #eef2f7;
        padding-bottom: 6px;
        margin-bottom: 10px;
      }
      .card-summary {
        border-left: 5px solid #2d98ff;
      }
      .card-prob {
        border-left: 5px solid #00c896;
      }
      .card-input {
        border-left: 5px solid #f6b93b;
      }
      .prediction-label {
        font-size: 22px;
        font-weight: 700;
      }
      .prediction-tag {
        display: inline-block;
        padding: 5px 14px;
        border-radius: 999px;
        background: linear-gradient(90deg, #4facfe, #00f2fe);
        font-size: 14px;
        color: #ffffff;
        margin-top: 6px;
      }
      .section-title {
        font-size: 18px;
        font-weight: 600;
        margin-top: 4px;
        margin-bottom: 4px;
      }
      .tips-text {
        font-size: 14px;
      }
      .btn-primary.btn-block {
        width: 100%;
        font-weight: 600;
      }
      .table > tbody > tr > td,
      .table > thead > tr > th {
        border-top: none !important;
      }
    "))
  ),

  titlePanel(NULL),

  fluidRow(
    column(
      width = 4,
      div(
        class = "card",
        h3(class = "app-title", "Obesity Level Predictor"),
        div(class = "subtitle",
            "Enter your details to estimate your obesity level and understand what it means for your health.")
      ),

      div(
        class = "card card-input",
        h4(class = "section-title", "Enter your details"),

        selectInput("Gender", "Gender:",
                    choices = levels(data$Gender)),

        numericInput("Age", "Age (years):",
                     value = 21, min = 5, max = 80, step = 1),

        numericInput("Height", "Height (meters):",
                     value = 1.65, min = 1.2, max = 2.2, step = 0.01),

        numericInput("Weight", "Weight (kg):",
                     value = 60, min = 20, max = 200, step = 0.5),

        selectInput("family_history_with_overweight",
                    "Family history of overweight:",
                    choices = levels(data$family_history_with_overweight)),

        selectInput("FAVC", "Frequent high-caloric food (FAVC):",
                    choices = levels(data$FAVC)),

        numericInput("FCVC", "Vegetable consumption (1–3):",
                     value = 2, min = 1, max = 3, step = 1),

        numericInput("NCP", "Number of main meals per day (1–4):",
                     value = 3, min = 1, max = 4, step = 1),

        selectInput("CAEC", "Eating between meals (CAEC):",
                    choices = levels(data$CAEC)),

        selectInput("SMOKE", "Do you smoke?:",
                    choices = levels(data$SMOKE)),

        numericInput("CH2O", "Daily water intake (liters, 1–3):",
                     value = 2, min = 1, max = 3, step = 1),

        selectInput("SCC", "Monitor calories consumed (SCC):",
                    choices = levels(data$SCC)),

        numericInput("FAF", "Physical activity (hours per week, 0–3):",
                     value = 1, min = 0, max = 3, step = 1),

        numericInput("TUE", "Technology use (hours per day, 0–2):",
                     value = 1, min = 0, max = 2, step = 1),

        selectInput("CALC", "Alcohol intake (CALC):",
                    choices = levels(data$CALC)),

        selectInput("MTRANS", "Main transportation (MTRANS):",
                    choices = levels(data$MTRANS)),

        br(),
        actionButton("predict_btn", "Predict Obesity Level",
                     class = "btn btn-primary btn-block")
      )
    ),

    column(
      width = 8,

      div(
        class = "card card-summary",
        h4(class = "section-title", "Prediction Summary"),
        textOutput("prediction_text"),
        div(class = "prediction-tag", textOutput("prediction_label")),
        br(), br(),
        strong("What this level means:"),
        p(textOutput("prediction_description")),
        br(),
        strong("General suggestion:"),
        p(class = "tips-text", textOutput("prediction_tips"))
      ),

      div(
        class = "card card-prob",
        h4(class = "section-title", "Class Probabilities"),
        p("These are the estimated probabilities for each obesity level:"),
        tableOutput("prob_table")
      ),

      div(
        class = "card",
        h4(class = "section-title", "Your Input (for reference)"),
        tableOutput("input_table")
      )
    )
  )
)

# ---------------------------------------------------------
# SERVER
# ---------------------------------------------------------
server <- function(input, output, session) {

  # Build a one-row data frame from user inputs
  user_data <- reactive({
    data.frame(
      Gender                        = factor(input$Gender,
                                             levels = levels(data$Gender)),
      Age                           = as.integer(input$Age),
      Height                        = as.numeric(input$Height),
      Weight                        = as.numeric(input$Weight),
      family_history_with_overweight = factor(input$family_history_with_overweight,
                                              levels = levels(data$family_history_with_overweight)),
      FAVC                          = factor(input$FAVC,
                                             levels = levels(data$FAVC)),
      FCVC                          = as.numeric(input$FCVC),
      NCP                           = as.numeric(input$NCP),
      CAEC                          = factor(input$CAEC,
                                             levels = levels(data$CAEC)),
      SMOKE                         = factor(input$SMOKE,
                                             levels = levels(data$SMOKE)),
      CH2O                          = as.numeric(input$CH2O),
      SCC                           = factor(input$SCC,
                                             levels = levels(data$SCC)),
      FAF                           = as.numeric(input$FAF),
      TUE                           = as.numeric(input$TUE),
      CALC                          = factor(input$CALC,
                                             levels = levels(data$CALC)),
      MTRANS                        = factor(input$MTRANS,
                                             levels = levels(data$MTRANS))
    )
  })

  observeEvent(input$predict_btn, {
    df <- user_data()

    # Prediction (class)
    pred_class <- predict(model, newdata = df)

    # Prediction probabilities
    pred_prob  <- predict(model, newdata = df, type = "prob")
    prob_df    <- as.data.frame(t(pred_prob))
    colnames(prob_df) <- "Probability"
    prob_df$Class <- rownames(prob_df)
    prob_df       <- prob_df[, c("Class", "Probability")]

    pred_str <- as.character(pred_class)

    output$prediction_text <- renderText({
      "Based on the information you entered, your predicted obesity level is:"
    })

    output$prediction_label <- renderText({
      pred_str
    })

    output$prediction_description <- renderText({
      if (!is.null(class_descriptions[pred_str])) {
        class_descriptions[pred_str]
      } else {
        "Description not available for this class."
      }
    })

    output$prediction_tips <- renderText({
      if (!is.null(class_tips[pred_str])) {
        class_tips[pred_str]
      } else {
        "Maintain a balanced diet, regular exercise, and consult healthcare professionals for personalized advice."
      }
    })

    output$input_table <- renderTable({
  df <- df <- user_data()
  data.frame(
    Attribute = names(df),
    Value = as.character(t(df)),
    row.names = NULL
  )
})

    output$prob_table <- renderTable({
      prob_df
    }, rownames = FALSE, digits = 4)
  })
}

# ---------------------------------------------------------
# RUN APP
# ---------------------------------------------------------
shinyApp(ui = ui, server = server)
