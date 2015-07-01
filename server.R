
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(fpc)
library(RMySQL)
library(maps)
library(rworldmap)
library(rworldxtra)

source("C:/Users/USER/Desktop/web clustering ST-DBSCAN/stdbscan.r")

con <- dbConnect(MySQL(), user = 'root', pass = 'ipbadmin', host = 'localhost', dbname = 'stdbscan')

shinyServer(function(input, output, session) {
  
  # Combine the selected variables into a new data frame
  selectedData <- reactive({
    switch(input$daerah,
           klm = data <- dbReadTable(conn = con,name = 'dataKalimantan'),
           smt = data <- dbReadTable(conn = con,name = 'dataSumSel')
    )
    assign("data", data, envir = .GlobalEnv)
    return(data[, c(3, 1)])
  })
  
  judul <- reactive({
    switch(input$daerah,
           klm = capt <- "Forest Fires of Kalimantan",
           smt= capt <- "Forest Fires of South Sumatera")
    return(capt)
  })
  
  cluster <- reactive({
    stdbscan(selectedData(), input$eps1, input$eps2, input$minPts)
  })
  
  output$caption <- renderText({
    judul()
  })
  
  output$plot <- renderPlot({
    newmap <- getMap(resolution = "high")
    assign("newmap", newmap, envir = .GlobalEnv)
    selectedData()
    
    plot(newmap,
         xlim = range(data$longitude),
         ylim = range(data$latitude),
         col="grey90")
    
    res <- stdbscan(data, input$eps1,input$eps2, input$minPts)
    
    dataNew<- data.frame(longitude=data$longitude, latitude=data$latitude, date=data$date, clusters=res$cluster)
    assign("dataNew", dataNew, envir = .GlobalEnv)
    
    ## hitung banyaknya cluster
    time_class314<- unique(res$cluster)
    assign("time_class314", time_class314, envir = .GlobalEnv)
    
    ## mendefinisikan warna
    class314_col<-rainbow(length(time_class314))
    assign("class314_col", class314_col, envir = .GlobalEnv)
    
    ##Cluster Besar
    b<-0         	## untuk nyimpen cluster
    for (i in 1: length(unique(dataNew$clusters))){
      a<-nrow(data[dataNew$clusters==i,])
      if(a >= 30){
        b<- b+1
      }
    }
    assign("cb", b, envir = .GlobalEnv)
    
    ##Total Cluster
    max<-length(time_class314)
    max<- max-1
    assign("total", max, envir = .GlobalEnv)
    
    ## plot per cluster
    for(q in c(2:length(time_class314))){
      points(data$longitude[dataNew$clusters==time_class314[q]],
             data$latitude[dataNew$clusters==time_class314[q]], col='black', bg=class314_col[q], pch=21, cex=1.8)
    }
    
    ##plot noise
    points(data$longitude[dataNew$clusters==0], data$latitude[dataNew$clusters==0], col='black', bg='black', xlab='', ylab='', pch=25)
    
    noise <- length(data$latitude[dataNew$clusters==0])
    assign("noise", noise, envir = .GlobalEnv)
    
    legend("topleft", legend=time_class314[2:length(time_class314)], cex=0.6, pch=20, pt.cex=1.5, col=class314_col[2:42], ncol=5) 
  
  })
  
  outTotal <- reactive({
    input$eps1
    input$eps2
    input$minPts
    switch(input$daerah,
           klm = total <- total[],
           smt=  total <- total[])
    return(total)
  })
  
  outNoise <- reactive({
    input$eps1
    input$eps2
    input$minPts
    switch(input$daerah,
           klm = noise <- noise[],
           smt=  noise <- noise[])
    return(noise)
  })
  
  outBigCluster <- reactive({
    input$eps1
    input$eps2
    input$minPts
    switch(input$daerah,
           klm = big <- cb[],
           smt=  big <- cb[])
    return(big)
  })
  
  outSmallCluster <- reactive({
    input$eps1
    input$eps2
    input$minPts
    switch(input$daerah,
           klm = small <- total - cb[],
           smt=  small <- total - cb[])
    return(small)
  })
  
  output$total <- renderValueBox({
    valueBox(
      outTotal(), "Total Cluster", icon = icon("info-circle"),
      color = "light-blue"
    )
  })
  
  output$noise <- renderValueBox({
    valueBox(
      outNoise(), "Total Noise", icon = icon("info-circle"),
      color = "red"
    )
  })
  
  output$bigCluster <- renderValueBox({
    valueBox(
      outBigCluster(), "Big Cluster", icon = icon("info-circle"),
      color = "light-blue"
    )
  })
  
  output$smallCluster <- renderValueBox({
    valueBox(
      outSmallCluster(), "Small Cluster", icon = icon("info-circle"),
      color = "light-blue"
    )
  })
  
  outTable <- reactive({
    input$eps1
    input$eps2
    input$minPts
    switch(input$daerah,
           klm = dataNew <- dataNew[],
           smt=  dataNew <- dataNew[])
    return(dataNew)
  })
  
  output$table <- renderDataTable(outTable())
  
})
