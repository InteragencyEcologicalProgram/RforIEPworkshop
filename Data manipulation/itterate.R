## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
library(tidyverse)
library(knitr)
#purl("dataset restructuring.Rmd", output="restructure.R")
#source("Data manipulation/restructure.R")


## ------------------------------------------------------------------------

mean(filter(CBlong, Year == 1984)$CPUE)

mean(filter(CBlong, Year == 1985)$CPUE)

mean(filter(CBlong, Year == 1986)$CPUE)



## ------------------------------------------------------------------------

#first we set up an empty data frame to accept our output
output = data.frame(year = min(CBlong$Year):max(CBlong$Year), Mean = NA)


for (i in 1:nrow(output)) {   # sequence
  
  output$Mean[i] = mean(filter(CBlong, 
                               Year == output$year[i])$CPUE, na.rm = T)  #body
}



## ------------------------------------------------------------------------
# `<_>apply` Family Functions
?apply



## ----fun-lapply----------------------------------------------------------

lapply(1:5, FUN = `+`, 5)



## ----vectorized----------------------------------------------------------
1:5 + 5


## ----list-create---------------------------------------------------------

X <- list(
  Item1 = 1:5,
  Item2 = 6:10,
  Item3 = 11:20
)

X



## ----list-add5, eval=FALSE-----------------------------------------------
## 
## X + 5
## # Error in X + 5 : non-numeric argument to binary operator
## 


## ----list-lapply---------------------------------------------------------

lapply(X, FUN = `+`, 5)
lapply(X, FUN = `^`, 2)



## ----employees-list------------------------------------------------------

employees <- list(
  c("first", "last"),
  c("first", "last"),
  c("first", "last"),
  c("first", "last"),
  c("first")
)

employees



## ----employees-demo------------------------------------------------------

vapply(employees, FUN = `[`, FUN.VALUE = character(1L), 1)
vapply(employees, FUN = paste0, FUN.VALUE = character(1L), collapse = " ")



## ----X-display-----------------------------------------------------------

# display list `X` again for convenience
X



## ----vapply-matrix_out1--------------------------------------------------

vapply(X, FUN = function(x) {
  c(Min = min(x), Max = max(x), Mean = mean(x))
}, FUN.VALUE = numeric(3L))



## ----mean-temp-yr1-------------------------------------------------------

mean_temp_yr <- with(data = Zoop, expr = {
  
  s <- split(Temperature, f = Year)
  
  vapply(s, FUN = mean, FUN.VALUE = numeric(1L))
  
})

mean_temp_yr



## ------------------------------------------------------------------------

CBmeans = summarize(group_by(CBlong, Year), #group it by Year
                    MeanCPUE = mean(CPUE)) #Calculate Mean CPUE

CBmeans
#much faster than the loop!



