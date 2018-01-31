library(data.table) 
library(shiny)
library(shinyjs)
library(dplyr)
library(xts)
library(dygraphs)
library(TTR)


SP500 = fread(file = "./GSPC.csv")
names(SP500)[names(SP500) == 'Adj Close'] = 'AdjClose'
SP500$Volume = as.numeric(SP500$Volume)
SP500$Date = as.Date(SP500$Date,"%m/%d/%Y")
SPxts = xts(SP500[,c('Open','High','Low','Close')], order.by = SP500$Date)
SPVxts = xts(SP500[,'Volume'], order.by = SP500$Date)
SPVxts$Volume = as.numeric(SPVxts$Volume)