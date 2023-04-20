# Argus Media Technical Assessment

Made by **Henrique Oliveira** 

April 2023

Check out more info about at [apps.hodatascience.com.br](https://apps.hodatascience.com.br/)

## Task
The objective of the assessment is to create *R Shiny* app that allows user to select and import financial indices data, calculate the calculated as a Volume Weighted Average Price (VWAP) of the indeces price for each day that is included in the raw data, display it as a table and chart in the app and add a button to save the output as CSV file.

## Codes Overview
The `app.R` file contains the code to run the web application. It is the main file that defines the user interface and server logic of a *R Shiny* app.
The `function.R` file contains all functions used in the app
The `www` folder contains the dataset and a image used in the app 

## App structure

### Sidebar Panel
* Import Data: Allows the user to upload a CSV file containing the indices data.
* Deal Date Range: Allows the user to select a date range for the deals to be analyzed.
* Indices: Allows the user to select which indices to analyze.
* Output: Contains buttons to submit the form and save the output as a CSV file.

### Main Panel
* Line Plot: Displays a line plot of the selected indices over time.
* Data Table: Displays a table of the selected indices, with their VWAP (Volume Weighted Average Price).
