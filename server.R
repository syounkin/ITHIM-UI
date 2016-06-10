library(shiny)
library(datasets)
library(ITHIM)
library(ggplot2)
library(reshape2)

# We tweak the "am" field to have nicer factor labels. Since this doesn't
# rely on any user inputs we can do this once at startup and then use the
# value throughout the lifetime of the application
#mpgData <- mtcars
#mpgData$am <- factor(mpgData$am, labels = c("Automatic", "Manual"))

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {

  # Compute the forumla text in a reactive expression since it is
  # shared by the output$caption and output$mpgPlot expressions
#  formulaText <- reactive({
#    paste("mpg ~", input$variable)
#  })

  # Return the formula text for printing as a caption
 # output$caption <- renderText({
 #   formulaText()
  #})

  # Generate a plot of the requested variable against mpg and only
                                        # include outliers if requested
#browser()
    
    parameters <- createParameterList(baseline = TRUE)
    means1 <- computeMeanMatrices(parameters)
    quintiles <- getQuintiles(means1)

    ITHIM.baseline <- list( parameters = parameters, means = means1, quintiles = quintiles )




 comparitiveRisk <- reactive({
    parameters <- createParameterList(baseline = FALSE)
    parameters <- setParameter(parName="muwt", parValue = input$muwt, parList = parameters)
    parameters <- setParameter(parName="muct", parValue = input$muct, parList = parameters)
    means2 <- computeMeanMatrices(parameters)
    quintiles <- getQuintiles(means2)
    ITHIM.scenario  <- list( parameters = parameters, means = means2, quintiles = quintiles )
    compareModels(ITHIM.baseline,ITHIM.scenario)
})
    output$ITHIMPlot <- renderPlot({
    #        plot(input$muwt)
            comparitiveRisk <- comparitiveRisk()
      #  hist(comparitiveRisk$RR.baseline[[as.character(input$variable)]]$M[,1])
      plotRR(comparitiveRisk$RR.baseline[[input$variable]],comparitiveRisk$RR.scenario[[input$variable]]) + coord_cartesian(ylim = c(0.75, 1.05))+ggtitle(as.character(input$variable))

  })


data <- reactive({
    foo <- comparitiveRisk()
    data.frame(foo$AF[[input$variable]])
    })
    
    output$values <- renderTable({
            data()
              })
})
