



function(input, output, session) {

  #Primary Chart. Due to bug, compress will need to be 
  #disabled to display moving averages.
  output$candle = renderDygraph({
    dygraph(SPxts,group = 'Main') %>%
      dyCandlestick(compress = TRUE) %>% 
      dyRangeSelector()
  })
  
  #Volatility
  output$vol = renderDygraph({
    dygraph(SPVxts, group = 'Main') %>%
      dyOptions(fillGraph = TRUE, maxNumberWidth = 30)#, labelsKMB = TRUE)
  })

  #Date display
  output$from <- renderText({
    if (!is.null(input$candle_date_window))
      strftime(input$candle_date_window[[1]], "%d %b %Y")
  })
  output$to <- renderText({
    if (!is.null(input$candle_date_window))
      strftime(input$candle_date_window[[2]], "%d %b %Y")
  })

observeEvent(input$calcMA,{
#Calculate Moving Averages
ifelse(input$MA1type=='Simple',
       (SP500 = mutate(SP500, MA1 = SMA(x = SP500$Close,n = input$MA1))),
       (SP500 = mutate(SP500, MA1 = EMA(x = SP500$Close,n = input$MA1)))
)
ifelse(input$MA2type=='Simple',
       (SP500 = mutate(SP500, MA2 = SMA(x = SP500$Close,n = input$MA2))),
       (SP500 = mutate(SP500, MA2 = EMA(x = SP500$Close,n = input$MA2)))
)

 SPxts2 = xts(SP500[,c('Open','High','Low','Close','MA1','MA2')], order.by = SP500$Date)

 output$candle = renderDygraph({
   dygraph(SPxts2,group = 'Main') %>%
     dyCandlestick() %>% 
     dyRangeSelector()
 })
})

observeEvent(input$clearMA,{
  SP500 = fread(file = "./GSPC.csv")
  names(SP500)[names(SP500) == 'Adj Close'] = 'AdjClose'
  SP500$Volume = as.numeric(SP500$Volume)
  SP500$Date = as.Date(SP500$Date,"%m/%d/%Y")
  SPxts = xts(SP500[,c('Open','High','Low','Close')], order.by = SP500$Date)
  
  output$candle = renderDygraph({
    dygraph(SPxts,group = 'Main') %>%
      dyCandlestick(compress = TRUE) %>% 
      dyRangeSelector()
  })
  
  
})  

observeEvent(input$backTest,{

  ifelse(input$MA1type=='Simple',
         (SP500 = mutate(SP500, MA1 = SMA(x = SP500$Close,n = input$MA1))),
         (SP500 = mutate(SP500, MA1 = EMA(x = SP500$Close,n = input$MA1)))
  )
  ifelse(input$MA2type=='Simple',
         (SP500 = mutate(SP500, MA2 = SMA(x = SP500$Close,n = input$MA2))),
         (SP500 = mutate(SP500, MA2 = EMA(x = SP500$Close,n = input$MA2)))
  )  
    
testFrame = mutate(SP500, off = shift(SP500$MA2,n = 1,type = "lead"), holdoff = shift(SP500$Close, n = input$hold, type = "lead"))
testFrame = mutate(testFrame, cross = testFrame$MA1 > testFrame$MA2 & testFrame$MA1 <= testFrame$off)
testFrame = mutate(testFrame, holdReturn = (testFrame$Close / testFrame$holdoff - input$transaction * 2) - 1)
testFrame = mutate(testFrame, tradeOff = shift(testFrame$holdReturn, n = input$hold, type = "lead"))

testFrame = filter(testFrame,testFrame$cross)                   
                  
output$BackTest = renderDataTable(testFrame)

try(
write.csv(testFrame, file = "Backtest1.csv"),silent = TRUE
)
  

  
  
  
  
})

  
}