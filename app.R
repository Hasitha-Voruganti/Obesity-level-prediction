library(shiny)
library(shinythemes)
library(e1071)

# Load trained model
model <- readRDS("obesity_naive_bayes_model.rds")
ui <- fluidPage(
  
  theme = shinytheme("flatly"),
  
  tags$head(
    tags$style(HTML("
      body {
        background: linear-gradient(to right, #eef2f3, #dfe9f3);
        font-family: 'Segoe UI';
      }

      .main-title {
        text-align: center;
        font-size: 42px;
        font-weight: bold;
        color: #1565C0;
        margin-top: 20px;
        margin-bottom: 10px;
      }

      .sub-title {
        text-align: center;
        font-size: 18px;
        color: #555;
        margin-bottom: 30px;
      }

      .card {
        background: white;
        padding: 25px;
        border-radius: 20px;
        box-shadow: 0px 4px 15px rgba(0,0,0,0.1);
      }

      .result-box {
        background: #f8f9fa;
        padding: 20px;
        border-radius: 15px;
        border-left: 8px solid #1565C0;
        margin-top: 20px;
      }

      .suggestion-box {
        background: #ffffff;
        padding: 20px;
        border-radius: 15px;
        margin-top: 20px;
        box-shadow: 0px 2px 10px rgba(0,0,0,0.08);
      }

      .predict-btn {
        background-color: #1565C0 !important;
        color: white !important;
        border: none !important;
        width: 100%;
        font-size: 18px !important;
        border-radius: 10px !important;
      }
    "))
  ),
  
  div(class = "main-title",
      "AI Obesity Level Predictor"),
  
  div(class = "sub-title",
      "Machine Learning based health prediction using Naive Bayes"),
  
  fluidRow(
    
    column(
      4,
      
      div(class = "card",
          
          h3("Enter Details"),
          
          selectInput(
            "Gender",
            "Gender",
            choices = c("Female" = 0,
                        "Male" = 1)
          ),
          
          numericInput(
            "Age",
            "Age",
            value = 25,
            min = 1,
            max = 100
          ),
          
          numericInput(
            "Height",
            "Height (meters)",
            value = 1.70,
            min = 1,
            max = 2.5
          ),
          
          numericInput(
            "Weight",
            "Weight (kg)",
            value = 70,
            min = 20,
            max = 250
          ),
          
          sliderInput(
            "FAF",
            "Physical Activity",
            min = 0,
            max = 3,
            value = 1,
            step = 1
          ),
          
          sliderInput(
            "CH2O",
            "Daily Water Intake",
            min = 1,
            max = 3,
            value = 2,
            step = 1
          ),
          
          checkboxInput(
            "family_history",
            "Family History With Overweight",
            TRUE
          ),
          
          checkboxInput(
            "favc",
            "Frequent High Calorie Food",
            TRUE
          ),
          
          br(),
          
          actionButton(
            "predict",
            "Predict Obesity Level",
            class = "predict-btn"
          )
      )
    ),
    
    column(
      8,
      
      div(class = "card",
          
          h2("Prediction Dashboard"),
          
          uiOutput("prediction_ui"),
          
          uiOutput("suggestions_ui")
      )
    )
  )
)

server <- function(input, output) {
  
  observeEvent(input$predict, {
    
    bmi <- input$Weight / (input$Height ^ 2)
    
    new_data <- data.frame(
      Gender = as.numeric(input$Gender),
      Age = input$Age,
      Height = input$Height,
      Weight = input$Weight,
      family_history_with_overweight = ifelse(input$family_history, 1, 0),
      FAVC = ifelse(input$favc, 1, 0),
      FCVC = 2,
      NCP = 3,
      CAEC = 1,
      SMOKE = 0,
      CH2O = input$CH2O,
      SCC = 0,
      FAF = input$FAF,
      TUE = 1,
      CALC = 1,
      MTRANS = 4,
      BMI = bmi
    )
    
    pred <- predict(model, newdata = new_data)
    
    suggestion <- ""
    
    if(grepl("Insufficient_Weight", pred)) {
      
      suggestion <- paste(
        "• Increase nutrient-rich meals",
        "• Add healthy snacks between meals",
        "• Include proteins like eggs, milk, and nuts",
        "• Strength training can help healthy weight gain",
        "• Maintain proper sleep schedule",
        sep = "\n"
      )
      
    } else if(grepl("Normal_Weight", pred)) {
      
      suggestion <- paste(
        "• Continue maintaining balanced nutrition",
        "• Exercise at least 30 minutes daily",
        "• Stay hydrated throughout the day",
        "• Maintain regular sleep and eating habits",
        "• Periodic health checkups are recommended",
        sep = "\n"
      )
      
    } else if(grepl("Overweight_Level_I", pred)) {
      
      suggestion <- paste(
        "• Reduce sugary beverages and junk food",
        "• Increase walking and cardio activities",
        "• Monitor calorie intake regularly",
        "• Eat more vegetables and fiber-rich foods",
        "• Avoid late-night eating",
        sep = "\n"
      )
      
    } else if(grepl("Overweight_Level_II", pred)) {
      
      suggestion <- paste(
        "• Follow a structured diet plan",
        "• Increase physical activity gradually",
        "• Reduce processed food consumption",
        "• Drink sufficient water daily",
        "• Consider consulting a dietician",
        sep = "\n"
      )
      
    } else if(grepl("Obesity_Type_I", pred)) {
      
      suggestion <- paste(
        "• Begin a supervised weight-loss program",
        "• Avoid high-calorie fast foods",
        "• Engage in regular low-impact exercises",
        "• Monitor BMI and body weight weekly",
        "• Improve sleep and stress management",
        sep = "\n"
      )
      
    } else if(grepl("Obesity_Type_II", pred)) {
      
      suggestion <- paste(
        "• Seek professional medical guidance",
        "• Adopt strict portion control",
        "• Include daily physical movement",
        "• Reduce sedentary screen time",
        "• Track nutrition and activity consistently",
        sep = "\n"
      )
      
    } else {
      
      suggestion <- paste(
        "• Immediate lifestyle intervention is recommended",
        "• Consult healthcare professionals regularly",
        "• Follow medically supervised diet plans",
        "• Increase physical activity safely",
        "• Prioritize long-term sustainable habits",
        sep = "\n"
      )
    }
    
    output$prediction_ui <- renderUI({
      
      div(class = "result-box",
          
          h2(
            paste("Predicted Level:", pred),
            style = "color:#1565C0;"
          ),
          
          h4(
            paste("Calculated BMI:", round(bmi, 2))
          )
      )
    })
    
    output$suggestions_ui <- renderUI({
      
      div(class = "suggestion-box",
          
          h3("Health Suggestions"),
          
          tags$pre(
            suggestion,
            style = "
              font-size:16px;
              background:white;
              border:none;
              color:#333;
            "
          )
      )
    })
  })
}

shinyApp(ui = ui, server = server)