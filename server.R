



function(input, output, session) {

  
  output$candle = renderDygraph({
    dygraph(SPxts,group = 'Main') %>%
      dyCandlestick(compress = TRUE) %>% 
      dyRangeSelector()
  })
  
  output$BackTest = renderDataTable({SP500})

  
  output$vol = renderDygraph({
    dygraph(SPVxts, group = 'Main') %>%
      dyOptions(fillGraph = TRUE,maxNumberWidth = 20)
  })

      
  output$from <- renderText({
    if (!is.null(input$candle_date_window))
      strftime(input$candle_date_window[[1]], "%d %b %Y")
  })
  output$to <- renderText({
    if (!is.null(input$candle_date_window))
      strftime(input$candle_date_window[[2]], "%d %b %Y")
  })

observeEvent(input$calcMA,{



ifelse(input$MA1type=='Simple',
       (SP500 = mutate(SP500, mov1 = SMA(x = SP500$Close,n = input$MA1))),
       (SP500 = mutate(SP500, mov1 = EMA(x = SP500$Close,n = input$MA1)))
)
ifelse(input$MA2type=='Simple',
       (SP500 = mutate(SP500, mov2 = SMA(x = SP500$Close,n = input$MA2))),
       (SP500 = mutate(SP500, mov2 = EMA(x = SP500$Close,n = input$MA2)))
)



 SPxts2 = xts(SP500[,c('Open','High','Low','Close','mov1','mov2')], order.by = SP500$Date)

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
    dygraph(SPxts2,group = 'Main') %>%
      dyCandlestick() %>% 
      dyRangeSelector()
  })
  
  
})  

observeEvent(input$backTest,{

  ifelse(input$MA1type=='Simple',
         (SP500 = mutate(SP500, mov1 = SMA(x = SP500$Close,n = input$MA1))),
         (SP500 = mutate(SP500, mov1 = EMA(x = SP500$Close,n = input$MA1)))
  )
  ifelse(input$MA2type=='Simple',
         (SP500 = mutate(SP500, mov2 = SMA(x = SP500$Close,n = input$MA2))),
         (SP500 = mutate(SP500, mov2 = EMA(x = SP500$Close,n = input$MA2)))
  )  
    
testFrame = mutate(SP500, off = shift(SP500$mov2,n = 1,type = "lead"), holdoff = shift(SP500$Close, n = input$hold, type = "lead"))
testFrame = mutate(testFrame, cross = testFrame$mov1 > testFrame$mov2 & testFrame$mov1 <= testFrame$off)
testFrame = mutate(testFrame, holdReturn = (testFrame$Close / testFrame$holdoff - input$transaction * 2) - 1)
testFrame = mutate(testFrame, tradeOff = shift(testFrame$holdReturn, n = input$hold, type = "lead"))

testFrame = filter(testFrame,testFrame$cross)                   
#print(head(testFrame))                   
output$BackTest = renderDataTable(testFrame)

write.csv(testFrame, file = "Backtest.csv")

  

  
  
  
  
})

  
}