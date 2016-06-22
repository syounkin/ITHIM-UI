library(shiny)

shinyUI(pageWithSidebar(

headerPanel("ITHIM"),

sidebarPanel(
   # can we add a break and second line here to re-state what walking time is or provide an example (like "60 min/wk = x# y min walking trips/wk)
   sliderInput("muwt", "Mean Walking Time (min per week):",
                min=57.8, max=120, value=57.8),
    # ditto cycling, may want to rethink the inputs so that a user could change average walking trip length and average number of trips/week
    sliderInput("muct", "Mean Cycling Time (min per week):",
                min=3.0, max=300, value=200.5),
    radioButtons("region", "Region:",
                 c("Bay Area"="SFBayArea", "National"="national"),
                 inline = TRUE, selected = "SFBayArea", width = '100%'),
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
