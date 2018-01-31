

fluidPage(
titlePanel(h1("S&P 500")),
  
#  sidebarLayout(
#    sidebarPanel(
#      div(strong("From: "), textOutput("from", inline = TRUE)),
#      div(strong("To: "), textOutput("to", inline = TRUE))
#    ),
    mainPanel(
      
      div(strong("From: "), textOutput("from", inline = TRUE)),
      splitLayout(div(strong("To: "), textOutput("to", inline = TRUE)),
                  div(checkboxInput('volToggle', 'Display Volume'),align = 'right')
              )
                    ),
#  ),
  
  
  mainPanel(
    

    dygraphOutput("candle"),

    
    
    
    h1(textOutput("volTag")),
    conditionalPanel(condition = 'input.volToggle', 
      dygraphOutput("vol",height = "200px")
                   ),
#    div(style="display:inline-block",numericInput("MA1", "First Moving Average", value = 10, min = 1, max = 99, width = '120px')),
#        div(style="display:inline-block",numericInput("MA2", "Second Moving Average", value = 20, min = 1, max = 99, width = '120px'))

  #h2("Indicators"),
  tabsetPanel(
    tabPanel("Indicators",  
  radioButtons("Indicators", "Select Indicators:",
               choices = c('None','Moving Averages'#,'MACD'#, 'Ind3','Ind4', 'Ind5'
               ), inline = TRUE),
  


    conditionalPanel("input.Indicators=='Moving Averages'",
      splitLayout(
        numericInput("MA1", "Short Moving Average (Days)", value = 10, min = 1, max = 99),

        numericInput("MA2", "Long Moving Average(Days)", value = 20, min = 1, max = 99)
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
           br(),
           br(),
           br(),
           br()
           
           )
  )
  )
)
