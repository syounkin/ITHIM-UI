library(shiny)
library(datasets)
library(ITHIM)
library(ggplot2)
library(reshape2)

shinyServer(function(input, output) {

    ITHIM.baseline <- reactive({
    parameters <- createParameterList(vision = "baseline", region = input$region)
    means <- computeMeanMatrices(parameters)
    quintiles <- getQuintiles(means)
    list( parameters = parameters, means = means, quintiles = quintiles )
    })

    ITHIM.scenario <- reactive({
        parameters <- createParameterList(vision = "scenario", region = input$region)
        parameters <- setParameter(parName="muwt", parValue = input$muwt, parList = parameters)
        parameters <- setParameter(parName="muct", parValue = input$muct, parList = parameters)
        means <- computeMeanMatrices(parameters)
        quintiles <- getQuintiles(means)
        ITHIM.scenario  <- list( parameters = parameters, means = means, quintiles = quintiles )
    })

    comparitiveRisk <- reactive({
        ITHIM.scenario <- ITHIM.scenario()
        ITHIM.baseline <- ITHIM.baseline()
        compareModels(ITHIM.baseline,ITHIM.scenario)
    })

    output$ITHIMPlot <- renderPlot({
        comparitiveRisk <- comparitiveRisk()
        plotRR(comparitiveRisk$RR.baseline[[input$variable]],comparitiveRisk$RR.scenario[[input$variable]]) + coord_cartesian(ylim = c(0.5, 1))+ggtitle(as.character(input$variable))
    })

    output$MeanPlot <- renderPlot({
        ITHIM.scenario <- ITHIM.scenario()
        ITHIM.baseline <- ITHIM.baseline()
        plotMean(ITHIM.baseline$means,ITHIM.scenario$means, var = "meanWalkTime") + ggtitle("Mean Walking Time") + coord_cartesian(ylim = c(0, 240))
    })

    output$YLLPlot <- renderPlot({
        comparitiveRisk <- comparitiveRisk()
        plotBurden(comparitiveRisk$yll.delta, varName = "YLL")
    })

    output$YLDPlot <- renderPlot({
        comparitiveRisk <- comparitiveRisk()
        plotBurden(comparitiveRisk$yld.delta, varName = "YLD")
    })

    output$DALYPlot <- renderPlot({
        comparitiveRisk <- comparitiveRisk()
        plotBurden(comparitiveRisk$daly.delta, varName = "DALY")
    })

    output$DeathsPlot <- renderPlot({
        comparitiveRisk <- comparitiveRisk()
        plotBurden(comparitiveRisk$dproj.delta, varName = "Deaths")
    })

    data <- reactive({
        CR <- comparitiveRisk()
        with(CR, data.frame(dproj.delta = dproj.delta, daly.delta = daly.delta, yll.delta = yll.delta, yld.delta = yld.delta))
    })

    output$BurdenTable <- renderTable({
        data()
    })
})
