library(shiny)
library(datasets)
library(ITHIM)
library(ggplot2)
library(reshape2)

shinyServer(function(input, output) {

    parameters <- createParameterList(baseline = TRUE)
    means <- computeMeanMatrices(parameters)
    quintiles <- getQuintiles(means)
    ITHIM.baseline  <- list( parameters = parameters, means = means, quintiles = quintiles )

    ITHIM.scenario <- reactive({
        parameters <- createParameterList(baseline = FALSE)
        parameters <- setParameter(parName="muwt", parValue = input$muwt, parList = parameters)
        parameters <- setParameter(parName="muct", parValue = input$muct, parList = parameters)
        parameters <- setParameter(parName="muws", parValue = input$muws, parList = parameters)
        means <- computeMeanMatrices(parameters)
        quintiles <- getQuintiles(means)
        ITHIM.scenario  <- list( parameters = parameters, means = means, quintiles = quintiles )
    })

    comparitiveRisk <- reactive({
        ITHIM.scenario <- ITHIM.scenario()
        compareModels(ITHIM.baseline,ITHIM.scenario)
    })

    output$ITHIMPlot <- renderPlot({
        comparitiveRisk <- comparitiveRisk()
        plotRR(comparitiveRisk$RR.baseline[[input$variable]],comparitiveRisk$RR.scenario[[input$variable]]) + coord_cartesian(ylim = c(0.7, 1))+ggtitle(as.character(input$variable))
    })

    output$MeanPlot <- renderPlot({
        ITHIM.scenario <- ITHIM.scenario()
        plotMean(ITHIM.baseline$means,ITHIM.scenario$means, var = "meanWalkTime") + ggtitle("Mean Walking Time") + coord_cartesian(ylim = c(0, 240))
    })

    data <- reactive({
        CR <- comparitiveRisk()
        data.frame(CR$AF)
    })

    output$values <- renderTable({
        data()
    })
})
