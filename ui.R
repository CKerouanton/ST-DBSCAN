
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "Clustering ST-DBSCAN",
                  titleWidth = 250
                ),
  
  ## Sidebar content
  dashboardSidebar(
    width = 250,
    sidebarMenu(
      menuItem("Visualization", tabName = "visual", icon = icon("area-chart")),
      menuItem("Table", tabName = "tabel", icon = icon("table"))
    )
  ),
  
  ## Body content
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "visual",
              fluidRow(
                box(
                  width = 12,
                  title = "Hotspot Data", solidHeader = TRUE, collapsible = TRUE,
                  selectInput("daerah", label = "", choices = c("South Sumatera" = "smt", "Kalimantan" = "klm"), selected="klm")
                ),
                
                box(
                  width = 9,
                  solidHeader = TRUE,
                  h3(textOutput("caption"), align = "center"),
                  plotOutput("plot", height = 435)
                ),
                
                box(
                  width = 3,
                  title = "EPS 1", status = "primary", solidHeader = TRUE, collapsible = TRUE,
                  sliderInput("eps1", "", 0, 1.0, 0.95)
                ),
                
                box(
                  width = 3,
                  title = "EPS 2", status = "primary", solidHeader = TRUE, collapsible = TRUE,
                  sliderInput("eps2", "", 1, 30, 7)
                ),
                
                box(
                  width = 3,
                  title = "MinPts", status = "primary", solidHeader = TRUE, collapsible = TRUE,
                  sliderInput("minPts", "", 1, 10, 2)
                ),
                
                valueBoxOutput("total", width = 3),
                
                valueBoxOutput("bigCluster", width = 3),
                
                valueBoxOutput("smallCluster", width = 3),
                
                valueBoxOutput("noise", width = 3)
                
              )
      ),
      
      # Second tab content
      tabItem(tabName = "tabel",
              fluidRow(
                column(12,
                       dataTableOutput('table')
                )
              )
      )
    )
  )
)
