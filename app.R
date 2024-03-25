library(shiny)
library(shinysurveys)
library(tidyverse)
library(gsheet)
library(googlesheets4)
df<- gsheet2tbl("https://docs.google.com/spreadsheets/d/1Dkz_QBV1-WdE4A5Gd0o6rQXbYuCaoSDQNKihmr1i0IU/edit?usp=sharing", sheetid="feedback")



# df <- data.frame(question = "What is your favorite food?",
#                  option = "Your Answer",
#                  input_type = "text",
#                  input_id = "favorite_food",
#                  dependence = NA,
#                  dependence_value = NA,
#                  required = F)

ui <- fluidPage(
  surveyOutput(df = df,
               survey_title = "Feedback zum Referat",
               survey_description = "Bitte beantworten Sie die folgenden Fragen zum heutigen Referat:",
               theme = '#006376')
)

server <- function(input, output, session) {
  renderSurvey()
  
  observeEvent(input$submit, {
    response_data <- getSurveyData(custom_id=intToUtf8(sample(65:90,10)))
    response_data$date<- format(Sys.time(), "%Y-%m-%e %H:%M:%S")
    showModal(modalDialog(title = "Vielen Dank, dass Sie den Bogen ausgefüllt haben!","Die heutige Seminarsitzung ist nun vermutlich zu Ende.",
                          footer = modalButton("Fertig.")))
    # MySheet <- gs4_find() #Obtain the id for the target Sheet
    MySheet <-   gs4_get('https://docs.google.com/spreadsheets/d/1Dkz_QBV1-WdE4A5Gd0o6rQXbYuCaoSDQNKihmr1i0IU/edit#gid=1657397966')
    sheet_append(MySheet , data = response_data, sheet='S24')
  })
}

shinyApp(ui, server)