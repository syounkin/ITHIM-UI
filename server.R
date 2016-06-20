library(shiny)
library(datasets)
library(ITHIM)
library(ggplot2)
library(reshape2)

shinyServer(function(input, output) {

    ITHIM.baseline <- reactive({
    parameters <- createParameterList(vision = "baseline", region = input$region)
    means <- computeMeanMatrices(parameters)
    quintiles <- getQuintiles(means, parameters)
    list( parameters = parameters, means = means, quintiles = quintiles )
    })

    ITHIM.scenario <- reactive({
        parameters <- createParameterList(vision = "scenario", region = input$region)
        parameters <- setParameter(parName="muwt", parValue = input$muwt, parList = parameters)
        parameters <- setParameter(parName="muct", parValue = input$muct, parList = parameters)
        means <- computeMeanMatrices(parameters)
        quintiles <- getQuintiles(means, parameters)
        ITHIM.scenario  <- list( parameters = parameters, means = means, quintiles = quintiles )
    })

    comparitiveRisk <- reactive({
        ITHIM.scenario <- ITHIM.scenario()
        ITHIM.baseline <- ITHIM.baseline()
        compareModels(ITHIM.baseline, ITHIM.scenario)
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

    deaths <- reactive({
        CR <- comparitiveRisk()
        matrix(unlist(lapply(CR$dproj.delta,function(x) lapply(x, function(x) sum(x[-(1:2)]) ))),nrow=5,ncol=2,byrow=TRUE,dimnames=list(names(CR$dproj.delta),c("M","F")))
    })

    daly <- reactive({
        CR <- comparitiveRisk()
        matrix(unlist(lapply(CR$daly.delta,function(x) lapply(x, function(x) sum(x[-(1:2)]) ))),nrow=5,ncol=2,byrow=TRUE,dimnames=list(names(CR$dproj.delta),c("M","F")))
    })

    yll <- reactive({
        CR <- comparitiveRisk()
        matrix(unlist(lapply(CR$yll.delta,function(x) lapply(x, function(x) sum(x[-(1:2)]) ))),nrow=5,ncol=2,byrow=TRUE,dimnames=list(names(CR$dproj.delta),c("M","F")))
    })

    yld <- reactive({
        CR <- comparitiveRisk()
        matrix(unlist(lapply(CR$yld.delta,function(x) lapply(x, function(x) sum(x[-(1:2)]) ))),nrow=5,ncol=2,byrow=TRUE,dimnames=list(names(CR$dproj.delta),c("M","F")))
    })

    output$DeathsTable <- renderTable({
        deaths()
    })
    output$DALYTable <- renderTable({
        daly()
    })
    output$YLLTable <- renderTable({
        yll()
    })
    output$YLDTable <- renderTable({
        yld()
    })
¯¯})
