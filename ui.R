

fluidPage(
titlePanel(h1("S&P 500")),
  
    mainPanel(
      
      div(strong("From: "), textOutput("from", inline = TRUE)),
      splitLayout(div(strong("To: "), textOutput("to", inline = TRUE)),
                  div(checkboxInput('volToggle', 'Display Volume'),align = 'right')
              )
                    ),

  
  mainPanel(
    
    dygraphOutput("candle"),

    h1(textOutput("volTag")),
    conditionalPanel(condition = 'input.volToggle', 
      dygraphOutput("vol",height = "200px")
                   ),
  tabsetPanel(
    tabPanel("Indicators",  
  radioButtons("Indicators", "Select Indicators:",
               choices = c('None','Moving Averages'
               ), inline = TRUE),
  


    conditionalPanel("input.Indicators=='Moving Averages'",
      splitLayout(
        sliderInput("MA1", "Short Moving Average (Days)", value = 10, min = 1, max = 200),

        sliderInput("MA2", "Long Moving Average(Days)", value = 20, min = 1, max = 200)
      ),
      splitLayout(
        radioButtons('MA1type',choices = c('Simple','Exponential'),label = NULL,inline = TRUE),
        radioButtons('MA2type',choices = c('Simple','Exponential'),label = NULL,inline = TRUE)

      ),
      splitLayout(
        actionButton("calcMA",'Calculate'),
        actionButton("clearMA",'Clear')
      )
    ),
  br(),
  br(),
  br()
    ),
  tabPanel("Backtesting",
           numericInput("hold", "Holding Period(Days)",min = 1, max = 30, value = 5),
           numericInput('transaction', 'Transaction Cost %', min = 0.0, max = 9.9, value = 0.0),
           actionButton("backTest","Test"),
           
           
           
           br(),
           br(),
           br()#,
           #tableOutput("BackTest")
           
           )
#  tabPanel("Help",tableOutput("BackTest"))
  )

 

  )
)
