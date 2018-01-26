

fluidPage(
titlePanel("S&P 500"),
  
  sidebarLayout(
    sidebarPanel(
      dateRangeInput("dateRange", label = h3("DateRange"),
                     start = min(index(SPxts)), 
                     end = max(index(SPxts)), 
                     min = min(index(SPxts)), 
                     max = max(index(SPxts))
                     )
    ),
    mainPanel()
  ),
  
  
  mainPanel(
    dygraphOutput("candle")
  )

)
