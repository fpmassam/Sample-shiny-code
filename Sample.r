library(shiny)
library(ggplot2)
library(ggthemes)
library(papaja)
library(scales)
library(Cairo)
library(ggiraph)
Salvini <- read.csv("datasetShiny.csv")

ui <- fluidPage(
   
  titlePanel("Matteo Salvini ~ Sentiment Analysis"),
  sidebarLayout(
   sidebarPanel(selectInput("Format", label = h3("Format"),
                             choices = c(unique(as.character(Salvini$Format)))),
                 helpText("Facebook sentiment aggregated by day, not by single post")),
 
    mainPanel(ggiraphOutput("plot1"))
     
    )
   
  )


# Define server logic required to draw a histogram
server <- function(input,output){
  category <- c("Facebook post", "European Parliament Speech")

 
  dat <- reactive({subset(Salvini, Format == input$Format)
    })

  output$plot1<- renderggiraph({
    p <-  ggplot(dat(), aes(y = Sentiment, x = as.Date(Date))) + geom_point_interactive(aes(size = Value, fill = Sentiment, tooltip = Value), shape = 21) + theme_apa() + xlab("Date") + theme(axis.text.x=element_text(angle=90, hjust=1), legend.position = 'bottom')
    ggiraph(code = print(p))
   
   
  })
}


# Run the application
shinyApp(ui = ui, server = server)
