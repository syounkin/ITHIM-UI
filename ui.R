library(shiny)

shinyUI(pageWithSidebar(

headerPanel("ITHIM"),

sidebarPanel(
    sliderInput("muwt", "Mean Walking Time (min per week):",
                min=47.4, max=120, value=57.8),
    sliderInput("muct", "Mean Cycling Time (min per week):",
                min=6.2, max=120, value=46.8),
    radioButtons("region", "Region:",
                 c("National"="national", "Also National"="national"),
                 inline = TRUE, selected = "national", width = '100%'),
    width = 2),

mainPanel(
    tabsetPanel(
        tabPanel("Deaths", plotOutput("DeathsPlot",height="400px")),
        tabPanel("DALY", plotOutput("DALYPlot",height="400px")),
        tabPanel("YLD", plotOutput("YLDPlot",height="400px")),
        tabPanel("YLL", plotOutput("YLLPlot",height="400px")),
        tabPanel("Table", tableOutput("BurdenTable")),
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
