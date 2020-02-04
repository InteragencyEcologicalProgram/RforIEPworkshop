## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## ----imports-------------------------------------------------------------
?read.csv

CBdata = read.csv("CBdata.csv", stringsAsFactors = F)
head(CBdata)



## ----excel---------------------------------------------------------------

library(readxl)

?read_excel

#CBdata = read_xlsx("1972-2018CBMatrix.xlsx", sheet = "CB CPUE Matrix 1972-2018")
#Yuck. If you have too many blanks in the begining of your sheet, it thinks it is
#a logical vector. Let's fix that.

CBdata = read_excel("1972-2018CBMatrix.xlsx", 
    sheet = "CB CPUE Matrix 1972-2018", col_types = c("numeric", 
        "numeric", "numeric", "numeric", 
        "date", "text", "text", "text", "numeric", 
        "text", "numeric", "text", rep("numeric", 62)))

head(CBdata)



## ------------------------------------------------------------------------

#Set up the path to a temporary file where we can store the data set
tf <- tempfile(pattern = "thisone", fileext = ".xlsx")

#download the file from online
#This time we'll go for the mysid database

download.file(
  url = "ftp://ftp.wildlife.ca.gov/IEP_Zooplankton/1972-2018MysidMatrix.xlsx",
  # destfile = tempfile(fileext = ".xlsx")
  destfile = tf,
  mode = "ab"
)

#now use the readxl file to bring it into your environment
Zoop <- readxl::read_excel(
  path = tf,
  sheet = "Mysid CPUE Matrix 1972-2018 "
)

#get rid of the temporary excel file we created
unlink(tf)



## ----rename--------------------------------------------------------------
library(tidyverse)

names(CBdata)

#several options for how to rename your colums

names(CBdata)[names(CBdata)== "SurveyCode"] = "cheese"

names(CBdata)

#you could also just make a new column and delete the old one
CBdata$crackers = CBdata$cheese
CBdata$cheese = NULL

names(CBdata)

#using "rename" is a little more intuitive
CBdata = rename(CBdata, SurveyCode = crackers)

names(CBdata)



## ------------------------------------------------------------------------

#Here is how you drop a column in base R

CBdata2 = subset(CBdata, select = -ALLCYCADULTS)

#but we can do more complicated selections with the "select" function from dplry
?select

CBdata2 = select(CBdata, -starts_with("ALL"))


## ------------------------------------------------------------------------
#here's how to do it in base R
CBdata2 = CBdata2[,c(67, 1:66)]

names(CBdata2)

#you can also use the "select" function in dplyr to do the same thing, but you 
#can list the columns by name
CBdata2 = select(CBdata2, Survey, Year, SurveyCode, SurveyRep:CRABZOEA)

names(CBdata2)

#I just learned this cool thing when you have a lot of columns!
CBdatatest = select(CBdata2, DAPHNIA, everything())

names(CBdatatest)



## ----mutate--------------------------------------------------------------

#In base R, we can just define a new variable and assign its value with the old variable
CBdata$ln_cals = log(CBdata$ALLCALADULTS + 1)

#or we can use the "mutate" function from dplyr. This is especially
#helpful if you want to make a bunch of variables at once

CBdata = mutate(CBdata, ln_clads = log(ALLCLADOCERA + 1), ln_cyc = log(ALLCYCADULTS +1), ln_all = ln_cals + ln_cyc + ln_clads)

View(CBdata)



## ------------------------------------------------------------------------


str(CBdata2)

#changing things from characters to factors and back again is really easy
#the "Region" variable would make a good factor

CBdata2$Region = as.factor(CBdata2$Region)

#or we can do it with "mutate" again
CBdata2 = mutate(CBdata2, Station = as.factor(Station)) 

str(CBdata2)

levels(CBdata2$Region)



## ------------------------------------------------------------------------
?factor

CBdata2$Region = factor(CBdata2$Region, 
                        levels = c("NapaR", "SPBay", 
                                   "CarStrait",  "SuiBay", "SuiMar", "EZ",
                                   "WestDel", "SacR","SJR",
                                   "NEDel","NorDel","SoDel","EastDel"),
                        labels = c("Napa River", "San Pablo Bay",
                                   "Carquinez", "Suisun Bay", "Suisun Marsh",
                                   "EZ", "West Delta", "Sacramento River",
                                   "San Joaquin River", "North East Delta",
                                   "North Delta", "South Delta", "East Delta")
                        )

levels(CBdata2$Region)



## ------------------------------------------------------------------------
CBdata2 = mutate(CBdata2, CRABZOEA_yn = as.logical(CRABZOEA))

View(CBdata2)

CBdata2 = select(CBdata2, -CRABZOEA_yn)


