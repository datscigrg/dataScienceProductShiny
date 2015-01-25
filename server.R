library(UsingR)
library(ggplot2)
library(shiny)
library(sqldf)

data <- read.csv("consumption1.csv", sep=",", header=T,skip =1)

colnames(data)[1] <- "Date"
colnames(data)[2] <- "HeatProduction"
# read data file
shinyServer(function(input, output) {
  dataInput <- reactive({
   
    cat(input$euro) 
    # detect type of input and select data
    if(input$calc=="Heat Production"){
      # simply select data from the file
      selectstring<-paste("select*from data where Date like '",input$year,sep="")  
      completeSelect<-paste(selectstring,"%' order by Date",sep="")
      cat(completeSelect)
      sqldf(completeSelect)
      #cat("select*from data where Date like '2014%' order by Date")
      #sqldf("select*from data where Date like '2014%' order by Date", input$year)
    } else if(input$calc=="Electricity Consumption"){
      # calculate eletrical energy consumption 
      selectstring<-paste("select Date, (HeatProduction/4) as HeatProduction from data where Date like '",input$year,sep="")
      completeSelect<-paste(selectstring,"%' order by Date",sep="")
      cat(completeSelect)
      sqldf(completeSelect)
      #sqldf("select Date, (HeatProduction/4) as HeatProduction from data where Date like '2014%' order by Date")
    } else {
      # calculate the costs 
      cat(input$euro)
      selectstring<-paste("select Date, (HeatProduction/4) as HeatProduction from data where Date like '",input$year,sep="")
      completeSelect<-paste(selectstring,"%' order by Date",sep="")
      cat(completeSelect)
      res<-sqldf(completeSelect)
      #res<-sqldf("select Date, (HeatProduction/4) as HeatProduction from data where Date like '2014%' order by Date", input$euro)
      res$CostInEuro <- res$HeatProduction * input$euro
      res
    }
  })
  ## Fill in the spot we created for a plot
  output$plot1 <- renderPlot({
    ## Render a barplot and print it case dependent
    print(as.matrix(dataInput()),quote=F)
    if(input$calc=="Heat Production")
    ggplot(dataInput(), aes(x=Date, y=HeatProduction)) + geom_bar(stat="identity") + 
      labs(x="Year", y="Heat Production in kWh") + geom_hline(aes(yintercept=mean(HeatProduction), colour="red"))
    else if(input$calc=="Electricity Consumption")
      ggplot(dataInput(), aes(x=Date, y=HeatProduction)) + geom_bar(stat="identity") + 
      labs(x="Year", y="Electrical power consumption in kWh") + geom_hline(aes(yintercept=mean(HeatProduction), colour="red"))
    else
      ggplot(dataInput(), aes(x=Date, y=CostInEuro)) + geom_bar(stat="identity") + 
    labs(x="Year", y="Cost in Euro") + geom_hline(aes(yintercept=mean(CostInEuro), colour="red"))
  })
})
