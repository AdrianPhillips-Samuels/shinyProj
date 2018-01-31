



function(input, output, session) {

 # chartData = reactive({SPxts})
  
  output$candle = renderDygraph({
    dygraph(SPxts,group = 'Main') %>%
      dyCandlestick(compress = TRUE) %>% 
      dyRangeSelector()
  })
  
  

  
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
#                      SMA(x = SP500$Close,n = input$MA1),
#                      EMA(x = SP500$Close,n = input$MA1)),
#         mov2 = ifelse(input$MA2type=='Simple',
#                      SMA(x = SP500$Close,n = input$MA2),
#                      EMA(x = SP500$Close,n = input$MA2))         
#         )
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
})  
  
}