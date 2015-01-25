
library(shiny)
# overall UI defintion
shinyUI(
  # Bootstrap layout used
  fluidPage(
    #  title of panel and page
    titlePanel("Heat production and electricity consumption of a geothermal heat pump"),
    # Generate a row with a sidebar
    sidebarLayout(
      # Define the sidebar with two inputs and a slide and a help text
      sidebarPanel(
        selectInput("calc", "Type of calculation:",
                    choices=c("Heat Production","Electricity Consumption", "Cost")),
        selectInput("year", "Year:",
                    choices=c("2013","2014")),
        hr(),
        sliderInput('euro', 'Enter price in cent',value = 0.24, min = 0.22, max = 0.28, step = 0.005),
        helpText("Data from my personal geothermal heat pump  (since 2014).", br(),
                 "Select the type of calculation and the year to get the appropriate bar plot.
                 You can choose different kind of calculations. Heat production shows the heat produced in kWh. Also the Electricity Consumption in kWh
                 can be shown. Finally, the total cost of running the heat pump can be presented. The slider is used to enter the
                 cost of a kWh in Euro.")),
      
      # Create the barplot
      mainPanel(
        plotOutput("plot1")))))