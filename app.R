# Argus Media Technical Assessment
# Made by Henrique Oliveira
# April 2023

#### INTRO ####

# Load packages
library(shiny)
library(shinyWidgets)
library(bslib)
library(tidyverse)
library(lubridate)
library(shinyalert)
library(plotly)
library(DT)

# Load functions
source("functions.R")

#### USER INTERFACE ####

ui <- fluidPage(
  
  # Set Bootstrap theme
  theme = bs_theme(bootswatch = "cerulean"),
  
  # App title
  titlePanel(h3(tags$b("Indices Analyzer App"),
                tags$small(tags$em(" created by Henrique Oliveira")),
                align = "left"),
             windowTitle = "Indices Analyzer App"),

  hr(),

  sidebarLayout(

    #### SIDEBAR ####

    sidebarPanel(
      width = 2,
      a(href = "https://www.argusmedia.com/", img(src = "logo.png", width = "100%")),
      hr(),

      sibebar_section("Import Data"),
      import_data(),
      hr(),

      sibebar_section("Deal Date Range"),
      dates_range(df),
      hr(),

      sibebar_section("Indices"),
      indices_picker(df),
      hr(),

      hr(),
      sibebar_section("Output"),
      output_buttons()
    ),

    #### MAIN PANEL ####

    mainPanel(
      width = 10,
      
      tabsetPanel(
        tabPanel("Line Plot",
                 br(),
                 plotlyOutput("plot")),
        tabPanel("Data Table",
                 br(),
                 dataTableOutput("table"))
      )
    )
  )
)

# Apply server logic
server <- function(input, output, session) {
  
  df <- eventReactive(input$import_data, {

    # Requested inputs
    req(input$import_data)

    # Read input files
    df <- read_csv(input$import_data$datapath)
    
    # Data pre-processing
    df <- df %>%
      set_dates_format() %>%
      create_indices_column() %>%
      filter_deal_period() %>%
      drop_na()
  })

  #### UPDATE FILTERS ####

  observeEvent(df(), {
    updateDateInput(session,
                    "init_date",
                    value = min(df()$`DEAL DATE`),
                    min = min(df()$`DEAL DATE`),
                    max = max(df()$`DEAL DATE`)
    )
    updateDateInput(session,
                    "final_date",
                    value = max(df()$`DEAL DATE`),
                    min = min(df()$`DEAL DATE`),
                    max = max(df()$`DEAL DATE`)
    )
    updatePickerInput(session,
                      "indices_picker",
                      choices = c("All", unique(df()$INDICES)),
                      selected = "All")
  })

  #### REACTIVE DATA ####

  # Reactive df
  df_react <- eventReactive(input$submit, {
    if (input$init_date <= input$final_date) {
      if (input$indices_picker == "All") {
        df_react <- df() %>%
          filter_date(input)
      } else {
        df_react <- df() %>%
          filter_date(input) %>%
          filter(INDICES == input$indices_picker)
      }
    }
  })

  # Create table data
  df_table <- eventReactive(input$submit, {
    calculate_VWAP(df_react())%>%
      select(-c(hoover_text)) %>%
      mutate(VWAP = round(VWAP, 2))
  })

  #### RENDER PLOT AND TABLE ####

  # Render plot output
  output$plot <- renderPlotly({
    line_plot(calculate_VWAP(df_react()))
  })

  # Render table output
  output$table <- renderDT(df_table(),
                           options = list(columnDefs = list(list(className = 'dt-center', targets = "_all"))))

  #### WRITE OUTPUT AND MSG ####

  # Display fail message
  observeEvent(input$submit, {
    if (input$init_date > input$final_date) {
      shinyalert(title = "Set Initial Date Before Final Date!", type = "error")
    }
  })

  # Write output file
  observeEvent(input$save, {

    # Display fail message
    if (is.null(input$import_data)) {
      shinyalert(title = "Load Input File!", type = "error")
    } else if (input$init_date > input$final_date) {
      shinyalert(title = "Set Initial Date Before Final Date!", type = "error")
    } else {

      # Generate output file
      write.csv(df_table(), "indices_output.csv", row.names = FALSE)

      # Display success message
      shinyalert(title = "Output Created!", type = "success")
    }
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
