library(shiny)
library(rCharts)
library(dplyr)
qbDVOA <- read.csv('qbDVOA.csv', stringsAsFactors=F)

shinyServer(function(input, output, session){
  
  output$value <- renderPrint({ input$checkGroup })

## Select/Deselect All radio buttons
  observe({   

    if (input$Select == 1) {
     updateCheckboxGroupInput(session = session, inputId="checkGroup",
                       choices=sort(qbDVOA$player), selected=sort(qbDVOA$player))
    } 
    if (input$Select == 2) {
      updateCheckboxGroupInput(session=session,inputId="checkGroup",
                               choices=sort(qbDVOA$player), selected=NULL)
    }     
  })
  
  output$h1 <- renderChart2({
    
    # Get subset of data from selected players
    qbData <- qbDVOA[qbDVOA$player %in% input$checkGroup, ]
    # Order data by name in abc order
    qbData <- arrange(qbData, player)
    
    # Initiate plotting environment
    h1 <- Highcharts$new()
    
    # Start making the graph
    h1$chart(type = 'bar', width = 700, height = 875, zoomType = 'x',
             resetZoomButton = list(position = list(y = -75)), marginTop = 135,
             spacingTop = 0, spacingLeft = -5)
    
    # avg opp pass def dvoa layer
    h1$series(data = qbData$avg_pass_def, name = 'AVG Opponent Pass Def DVOA %',
              visible = F, color='#74c476')
    
    # Avg opp def dvoa layer
    h1$series(data = qbData$avg_def_dvoa, name = 'AVG Opponent Def DVOA %',
              visible = F, color='#d01c8b')
    # avg opp total dvoa layer
    h1$series(data = qbData$avg_tot_dvoa, name = 'AVG Opponent Total DVOA %',
              visible = F, color='#f4a582')
    
    # Passing DVOA layer
    h1$series(data = qbData$dvoa, name = 'Passing DVOA %', color='#0571b0')
    
    h1$subtitle(text = "Zoom in by left clicking and dragging vertically over the graph. Select/unselect which DVOA stat to plot by clicking it in the legend below. Save/print an image of this graph using the dropdown menu in the top right.")
    h1$xAxis(title = list(text = 'Player', style = list(fontWeight = 'bold', fontSize = '14px')),
             categories = qbData$player, labels = list(style = list(fontSize = '14px')))
    h1$yAxis(title = list(text = 'DVOA %', style = list(fontWeight = 'bold',
                                                        fontSize = '14px')),
             gridZIndex = 4, gridLineColor = 'white',gridLineWidth = 2,
             opposite = T, labels = list(style = list(fontSize = '14px')))
    h1$legend(enabled = T, width = 500, reversed = T, verticalAlign = 'top',
              y = 35, itemStyle = list(fontSize = '12px'))
    # h1$plotOptions(series = list(visible=T)) # Have all data visible
    h1$navigation(buttonOptions = (list(enabled = T)))
    h1$exporting(enabled = T)
    return(h1)
  })  
})