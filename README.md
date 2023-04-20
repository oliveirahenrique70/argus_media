# Argus Media Technical Assessment
## Made by Henrique Oliveira
## April 2023

# Task
The objective of the assessment is to create `R Shiny` application that allows user to select and import financial indices data, calculate the calculated as a Volume Weighted Average Price (VWAP) of the indeces price for each day that is included in the raw data, display it as a table and chart in the application and add a button to save the output as CSV file.

# Code Overview

This R Shiny code is an application that allows the user to analyze indices data. The app consists of a user interface (UI) and a server that handles user input and generates the output.

## User Interface (UI)
The UI is created using the fluidPage function from the shiny package. It contains two main panels: a sidebar panel and a main panel.

## Sidebar Panel
The sidebar panel contains several sections:

* Import Data: Allows the user to upload a CSV file containing the indices data.
* Deal Date Range: Allows the user to select a date range for the deals to be analyzed.
* Indices: Allows the user to select which indices to analyze.
* Output: Contains buttons to submit the form and save the output.

## Main Panel
The main panel contains two tabs:

Line Plot: Displays a line plot of the selected indices over time.
Data Table: Displays a table of the selected indices, with their VWAP (Volume Weighted Average Price).
Server
The server is created using the server function from the shiny package. It contains several reactive functions that handle user input and generate output.

Import Data
The df reactive function reads the CSV file uploaded by the user, performs some pre-processing (setting the dates format, creating the indices column, filtering by the selected date range, and dropping any missing values), and returns the resulting data frame.

Update Filters
The observeEvent function updates the values of the date range input (init_date and final_date) and the indices picker input (indices_picker) whenever the df reactive function is updated. The date range is set to the minimum and maximum dates of the DEAL DATE column of the data frame, and the indices picker choices are set to the unique values of the INDICES column of the data frame.

Reactive Data
The df_react and df_table reactive functions create subsets of the data frame based on the selected date range and indices, and calculate the VWAP for each index. The df_react function returns the subset of the data frame that matches the selected date range and indices, and the df_table function creates a table of the VWAP values for each index.

Render Plot and Table
The renderPlotly and renderDataTable functions generate the line plot and data table outputs based on the df_react and df_table reactive functions, respectively.

Write Output and MSG
The observeEvent function displays an error message if the initial date is set after the final date, and a success message when the output file is generated. The write.csv function creates a CSV file of the VWAP values for each index.
