# Argus Media Technical Assessment
## Made by Henrique Oliveira
## April 2023

# Task
The objective of the assessment is to create `R Shiny` application that allows user to select and import financial indices data, calculate the calculated as a Volume Weighted Average Price (VWAP) of the indeces price for each day that is included in the raw data, display it as a table and chart in the application and add a button to save the output as CSV file.

# Code Overview

## User Interface (UI)

### Sidebar Panel
* Import Data: Allows the user to upload a CSV file containing the indices data.
* Deal Date Range: Allows the user to select a date range for the deals to be analyzed.
* Indices: Allows the user to select which indices to analyze.
* Output: Contains buttons to submit the form and save the output as a CSV file.

### Main Panel
* Line Plot: Displays a line plot of the selected indices over time.
* Data Table: Displays a table of the selected indices, with their VWAP (Volume Weighted Average Price).
