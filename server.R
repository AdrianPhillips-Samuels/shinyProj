



function(input, output, session) {

  
  
  output$candle = renderDygraph({
    dygraph(SPxts) %>%
      dyCandlestick(compress = TRUE) %>% 
      dyRangeSelector(dateWindow = input$dateRange)
    
  })
#  observe({
#    output$from = candle$date_window[[1]]
#    output$to = candle$date_window[[2]]
#  })
}