#Export all my markdown files into R scripts so I can turn the markdown files into a web book
library(knitr)
purl("Data manipulation/dataset restructuring.Rmd", output="Data manipulation/restructure.R")
purl("Data manipulation/data mainpulation.Rmd", output="Data manipulation/datamanip.R")
purl("Data manipulation/applyfunctions.Rmd", output = "Data manipulation/itterate.R")
