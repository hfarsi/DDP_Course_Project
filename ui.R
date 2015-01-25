
library(shiny)
library(plyr)
library(ggplot2)

shinyUI(
    
    fluidPage(    
        
        titlePanel("Natural Climate Events in US - 2001 through 2013"),
        
        sidebarLayout(      
            
            sidebarPanel(
                selectInput("var1","Select summary by:",
                            c("Yearly_Trend", "Event_Types", "States"), selected = "Yearly_Trend"),
                br(),                
                selectInput("var2", "Impact on Economy (Crops+Properties damages) and Health (Death + Injuries):",
                            c("No_of_Events","Impact_on_Economy","Impact_on_Health"), 
                            selected="No_of_Events"),
                br(),
                sliderInput("bars",
                            "Top N values (bars in the graph):", min = 1, max = 50, step = 1,
                            value = 25),
                helpText("Values between 1 and 5 on the slidder displays the $amount and counts"),
                helpText("Note: For Yearly_Trend the slidder does not alter the number of bars."),
                br(),
                submitButton("Submit"),
                br(),
                helpText("Data from the U.S. National Oceanic and Atmospheric Administration's (NOAA)")
            ),
            
            mainPanel(
                plotOutput("myPlot",width=500,height=400)
            )
         )
    )
    
)