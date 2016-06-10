library(shiny)

# Define UI for miles per gallon application
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("ITHIM"),

  # Sidebar with controls to select the variable to plot against mpg
  # and to specify whether outliers should be included
  sidebarPanel(
    selectInput("variable", "Variable:",
                list("Depression" = "Depression",
                     "Dementia" = "Dementia",
                     "BreastCancer" = "BreastCancer",
                     "ColonCancer" = "ColonCancer",
                     "CVD" = "CVD",
                     "Diabetes" = "Diabetes")),
    sliderInput("muwt", "Mean Walking Time (min per week):",
                min=55, max=200, value=107),
    sliderInput("muct", "Mean Cycling Time (min per week):",
                min=10, max=200, value=39),
    sliderInput("muws", "Mean Walking Speed (mph):",
                min=2.7, max=5, value=2.8)
    #checkboxInput("outliers", "Show outliers", FALSE)
  ),

  # Show the caption and plot of the requested variable against mpg
  ## mainPanel(
  ##   h3(textOutput("variable")),

  ##   #plotOutput("ITHIMPlot"),
  ##   tableOutput("values")
  ## )

mainPanel(
        tabsetPanel(
                  tabPanel("R.R.", plotOutput("ITHIMPlot",height="800px")),
#                  tabPanel("Summary", verbatimTextOutput("summary")),
                  tabPanel("A.F.", tableOutput("values"))
                )
      )

))
