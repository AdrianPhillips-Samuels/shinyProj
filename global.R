library(data.table) 
library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(shinydashboard)
library(xts)
library(dygraphs)

SP500 = fread(file = "./GSPC.csv")
names(SP500)[names(SP500) == 'Adj Close'] = 'AdjClose'
SP500$Date = as.Date(SP500$Date,"%m/%d/%Y")
SPxts = xts(SP500[,c('Open','High','Low','Close')], order.by = SP500$Date)
