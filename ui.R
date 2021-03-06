library(shiny)

shinyUI(pageWithSidebar(

headerPanel("Simple Implementation of the ITHIM Tool for US Metropolitan Counties"),

## we should also think about how to allow for all the results of selected scenario to be downloaded as CSV
## I think users will be interested in seeing a scenario against baseline or a scenario against another so may think about duplicating 
## the current display to show the results of two runs side by side or atop one another
 
sidebarPanel(
   # can we add a break and second line here to re-state what walking time is or provide an example (like "60 min/wk = x# y min walking trips/wk)
   sliderInput("muwt", "Mean Walking Time (min per week):",
                min=20, max=100, value=47.49),
    # ditto cycling, may want to rethink the inputs so that a user could change average walking trip length and average number of trips/week
    sliderInput("muct", "Mean Cycling Time (min per week):",
                min=0, max=15, value=6.16),
    width = 2),

mainPanel(
    tabsetPanel(
        tabPanel("Deaths", plotOutput("DeathsPlot",height="400px")),
        tabPanel("DALY", plotOutput("DALYPlot",height="400px")),
        tabPanel("YLD", plotOutput("YLDPlot",height="400px")),
        tabPanel("YLL", plotOutput("YLLPlot",height="400px")),
        tabPanel("Deaths Summary", tableOutput("DeathsTable")),
        tabPanel("DALY Summary", tableOutput("DALYTable")),
        tabPanel("YLD Summary", tableOutput("YLDTable")),
        tabPanel("YLL Summary", tableOutput("YLLTable")),
        type = "pills"
    )
)

))

## selectInput("variable", "Variable:",
##             list("Depression" = "Depression",
##                  "Dementia" = "Dementia",
##                  "BreastCancer" = "BreastCancer",
##                  "ColonCancer" = "ColonCancer",
##                  "CVD" = "CVD",
##                  "Diabetes" = "Diabetes")),
