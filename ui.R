library(shiny)
library(rCharts)

qbDVOA <- read.csv('qbDVOA.csv')
qbDVOA$player <- as.character(qbDVOA$player)

shinyUI(pageWithSidebar(
  
  headerPanel(h3("QB Playoff Performance Based on DVOA 1989-2013 (min. 5 starts and 150 attempts)")),
  
  sidebarPanel(
#   wellPanel(
#     tags$style(type="text/css", '#leftPanel { width:180px; float:left;}'),
#     id = "leftPanel",
#                
    
    radioButtons("Select", label="Select or Deselect All Players (resets to Passing DVOA %)", 
                 choices = list("Select All" = 1, "Deselect All" = 2),
                 selected = 1),

    # Checkbox with qb player names
    checkboxGroupInput("checkGroup", label = "Player",
                        choices = sort(qbDVOA$player), selected=sort(qbDVOA$player)),
        
    br(),
    a(href = "http://www.footballoutsiders.com/stat-analysis/2014/nfls-best-playoff-quarterbacks-dvoa-and-dyar",
      "Football Outsiders Article with the Data"),
    
    width = 3
  ),
  
  mainPanel(
    showOutput("h1", "highcharts")
  )
))
