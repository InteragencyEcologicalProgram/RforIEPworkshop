## ----include=FALSE-------------------------------------------------------
library(tidyverse)
#source the data manipulation file if it wasn't run just before this
library(knitr)
#purl("Data manipulation/data mainpulation.Rmd", output="Data manipulation/datamaip.R")
source("Data manipulation/datamaip.R")



## ----vapply-matrix_out3--------------------------------------------------

#we can set up a quick data frame
X <- data.frame(
  Item1 = 1:5,
  Item2 = 6:10,
  Item3 = 11:20
)

X

#Then Transpose it
Y = t(X)
Y



## ------------------------------------------------------------------------
?pivot_longer

CBlong = pivot_longer(CBdata2, #specify the data set you want to pivot
                      cols = ACARTELA:CRABZOEA, #specify the coloms to pivot
                      names_to = "TaxonCode", #give the name of the new column you want to create
                      values_to = "CPUE" #name of the column for the values
                      )

View(CBlong)



## ------------------------------------------------------------------------
?pivot_wider

CBwide = pivot_wider(CBlong, #specify the data set you want to pivot
                      id_cols = c(Survey, Year, Date, Station), #Identifier columns (ones you don't want to pivot)
                      names_from = TaxonCode, #give the name of the new column you want to use for the names of the new columns
                      values_from = CPUE #name of the column for the values
                      )

View(CBwide)


## ------------------------------------------------------------------------

CBwideY = pivot_wider(CBlong, #specify the data set you want to pivot
                      id_cols = Year, #specify the column with the unique identifier
                      names_from = TaxonCode, #give the name of the new column you want to use for the names of the new columns
                      values_from = CPUE, #name of the column for the values
                      values_fn = list(CPUE = sum) #function to use to combine values
                      )

View(CBwideY)



## ------------------------------------------------------------------------

#first let's import the station lookup table from the excel file

taxalookup <- read_excel("1972-2018CBMatrix.xlsx", 
    sheet = "CB Taxa Lookup")
View(taxalookup)

#apparently the first row wasn't the column names! Oh no!

#let's rename that
names(taxalookup) =  c("TaxonCode", "TaxonName", "StartYear", "EndYear")
View(taxalookup)

#get rid of the first and last row
taxalookup = taxalookup[-c(1,58),]
View(taxalookup)



## ------------------------------------------------------------------------

?merge

CBlong2 = merge(CBlong, taxalookup, by = "TaxonCode")




## ------------------------------------------------------------------------
#for example, if we only had scientific names for some of our taxa
taxalookupshort = taxalookup[1:20,]

CBlong3 = merge(CBlong, taxalookupshort, by = "TaxonCode")
nrow(CBlong)
nrow(CBlong3)
#all the rows that weren't in the first 20 taxa have been dropped


CBlong4 = merge(CBlong, taxalookupshort, by = "TaxonCode", all.x = T)
nrow(CBlong4)
View(CBlong4)
#Empty values are now "NA"



## ----graphics, fig.align = 'center', echo = F----------------------------
knitr::include_graphics("joins.jpg")


## ------------------------------------------------------------------------

?join

#for a basic join, the syntax is simmilar
CBlong2 = inner_join(CBlong, taxalookup, by = "TaxonCode")

#but when things get more complicated, it's a little easier to see what you are doing
taxalookupshort = taxalookup[1:20,]

CBlong3 = inner_join(CBlong, taxalookupshort, by = "TaxonCode")
CBlong4 = left_join(CBlong, taxalookupshort, by = "TaxonCode")
nrow(CBlong)
nrow(CBlong3)
nrow(CBlong4)
View(CBlong4)
#Empty values are now "NA"






