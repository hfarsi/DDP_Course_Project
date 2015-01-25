
library(shiny)
library(plyr)
library(ggplot2)

# 

bigdata <- readRDS("cleanedData.rds")

devents <- ddply(bigdata, "EVENT_TYPE", summarise, No_of_Events = length(EVENT_TYPE),
                 Impact_on_Health = sum(health), Impact_on_Economy = sum(damages))
dyears  <- ddply(bigdata, "YEAR", summarise, No_of_Events = length(YEAR),
                Impact_on_Health = sum(health), Impact_on_Economy = sum(damages))
dstates <- ddply(bigdata, "STATE", summarise, No_of_Events = length(STATE),
                 Impact_on_Health = sum(health), Impact_on_Economy = sum(damages))

shinyServer(function(input, output) {
    
    output$myPlot <- renderPlot({
        
        if(input$var1 == "Yearly_Trend") {
            mydata <- dyears
            if(input$var2 == "No_of_Events") 
                g <- ggplot(mydata, aes(YEAR,No_of_Events))
            else if(input$var2 == "Impact_on_Health") 
                g <- ggplot(mydata, aes(YEAR,Impact_on_Health))
            else if(input$var2 == "Impact_on_Economy") 
                g <- ggplot(mydata, aes(YEAR,Impact_on_Economy))
        }
        if(input$var1 == "Event_Types") {
            mydata <- devents
            mydata <- mydata[order(mydata[,input$var2], decreasing = T),]
            
            if(input$var2 == "No_of_Events") 
                g <- ggplot(mydata[1:input$bars,], aes(x=reorder(EVENT_TYPE,No_of_Events), y=No_of_Events))
            else if(input$var2 == "Impact_on_Health") 
                g <- ggplot(mydata[1:input$bars,], aes(x=reorder(EVENT_TYPE,Impact_on_Health), y=Impact_on_Health))
            else if(input$var2 == "Impact_on_Economy") 
                g <- ggplot(mydata[1:input$bars,], aes(x=reorder(EVENT_TYPE,Impact_on_Economy), y=Impact_on_Economy))
        }
        if(input$var1 == "States") {
            mydata <- dstates
            mydata <- mydata[order(mydata[,input$var2], decreasing = T),]
        #    g <- ggplot(mydata[1:input$bars,], aes_string(x=reorder("STATE",input$var2), y=input$var2))
            if(input$var2 == "No_of_Events") 
                g <- ggplot(mydata[1:input$bars,], aes(x=reorder(STATE,No_of_Events), y=No_of_Events))
            else if(input$var2 == "Impact_on_Health") 
                g <- ggplot(mydata[1:input$bars,], aes(x=reorder(STATE,Impact_on_Health), y=Impact_on_Health))
            else if(input$var2 == "Impact_on_Economy") 
                g <- ggplot(mydata[1:input$bars,], aes(x=reorder(STATE,Impact_on_Economy), y=Impact_on_Economy))
        }    
        g <- g + geom_bar(stat="identity", fill="blue", colr="black")
        g <- g + xlab(input$var1) + ylab(input$var2) 
        g <- g + theme(axis.text.x = element_text(angle=60, hjust=1))
        if(input$bars <= 5) 
            g <- g + geom_text(aes_string(label=input$var2), vjust=1.2, color="white", size = 3.5)
        print(g)
    })
})
