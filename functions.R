#### DATA PRE-PROCESSING ####

filter_deal_period <- function(df) {
  df %>%
    filter(`DELIVERY DATE` - `DEAL DATE` <= 180) %>%
    filter(`DELIVERY DATE` - `DEAL DATE` >= 0)
}

set_dates_format <- function(df) {
  df %>%
    mutate(`DEAL DATE` = dmy(`DEAL DATE`)) %>%
    mutate(`DELIVERY DATE` = my(str_c(df$`DELIVERY MONTH`, "-", df$`DELIVERY YEAR`)))
}

create_indices_column <- function(df) {
  df %>%
    mutate(
      INDICES = case_when(
        COMMODITY == "Coal" & `DELIVERY LOCATION` %in% c("ARA", "AMS", "ROT", "ANT") ~ "COAL2",
        COMMODITY == "Coal" & `COMMODITY SOURCE LOCATION` == "South Africa" ~ "COAL4",
        TRUE ~ NA_character_
      )
    )
}

#### UI #####

sibebar_section <- function(title) {
  return(h5(tags$em(title), align = "center"))
}

import_data <- function() {
  fileInput(
    "import_data",
    NULL,
    accept = c("text/csv",
               "text/comma-separated-values,text/plain",
               ".csv")
  )
}

dates_range <- function(df) {
  tagList(
    dateInput(
      "init_date",
      label = "Inital:",
      value = ""
    ),
    dateInput(
      "final_date",
      label = "Final:",
      value = ""
    )
  )
}

indices_picker <- function(df) {
  pickerInput(
    inputId = "indices_picker",
    label = NULL,
    choices = NULL,
    options = pickerOptions(liveSearch = TRUE)
  )
}

output_buttons <- function() {
  div(actionButton("submit",
                   class = "btn btn-success",
                   label = "Submit"),
      actionButton("save",
                   class = "btn btn-warning",
                   label = "Save as CSV"),
      align = "center")
}

#### SERVER ####

filter_date <- function(df, input) {
  df %>%
    filter(`DEAL DATE` <= input$final_date) %>%
    filter(`DEAL DATE` >= input$init_date)
}

calculate_VWAP <- function(df) {
  df %>%
    group_by(`DEAL DATE`, INDICES) %>%
    summarise(`TOTAL VOLUME` = sum(VOLUME),
              `TOTAL PRICE` = sum(PRICE),
              `NUMBER OF INDICES` = n(),
              VWAP = sum(PRICE * VOLUME) / `TOTAL VOLUME`) %>%
    mutate(hoover_text = str_c(
      "<br>Index: ", INDICES,
      "<br>Deal Date: ", `DEAL DATE`,
      "<br>VWAP: ", round(VWAP, 2)))
}

line_plot <- function(df) {

  plot <- ggplot(df, aes(x = `DEAL DATE`, y = VWAP, color = INDICES)) +
  labs(title = "Volume Weighted Average Price (VWAP)", x = "Deal Date", color = "Index") +
  geom_line() +
  geom_point(aes(text = hoover_text), size = 0.5) +
  scale_x_date(date_labels = "%d %b") +
  theme_minimal() +
  scale_color_brewer(palette = "Set1") +
  theme(axis.text = element_text(size = 12),
        axis.title = element_text(size = 14),
        plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
        legend.title = element_text(size = 14),
        legend.text = element_text(size = 12))

  return(ggplotly(plot, tooltip = "text") %>%
           layout(height = 600, width = 1400))
}
