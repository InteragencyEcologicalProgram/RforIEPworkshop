
  - [Load Data](#load-data)
  - [Check Data](#check-data)
  - [Questions (from
    `applyfunctions.Rmd`)](#questions-from-applyfunctions.rmd)
  - [Questions (from `data
    mainpulaton.Rmd`)](#questions-from-data-mainpulaton.rmd)

# Load Data

Read the `.csv` file into your current R session. *Note*: your file path
to `file` may differ.

``` r
CBdata <- read.csv(
  file = "CBdata.csv",
  header = TRUE,
  stringsAsFactors = FALSE
)
```

# Check Data

Check your data with calls to built-in R functions. `dim` returns number
of rows and number of columns. We have many columns (n=74).

``` r
# check row and column count
dim(CBdata)
```

    ## [1] 22237    74

``` r
# long output, but a good option
# str(CBdata)
# summary(CBdata)
```

#### Check `NA`

Here, we write a custom function `CountNA` to help us count `NA`s and
character NAs. We pass the function to `FUN` in `vapply` - see next
step.

*Note*: for now `sum(x %in% c("NA", "na"))` will suffice to check for
character NAs. Likely, there are more robust ways, perhaps even using
`base::grepl` or the like.

``` r
CountNA <- function(x) {
  char_na <- sum(x %in% c("NA", "na"))
  c(CharNA = char_na, `NA` = sum(is.na(x)))
}
```

The output is long, but we see seven fields have count `NA` \> 0. Good
to know.

``` r
t(vapply(CBdata, FUN = CountNA, FUN.VALUE = numeric(2L)))
```

    ##                 CharNA    NA
    ## SurveyCode           0     0
    ## Year                 0     0
    ## Survey               0     0
    ## SurveyRep            0     0
    ## Date                 0     0
    ## Station              0     0
    ## EZStation            0 21662
    ## DWRStation           0 11813
    ## Core                 0     0
    ## Time                 0     0
    ## TideCode             0     0
    ## Region               0     0
    ## Secchi               0    64
    ## Chl.a                0  3809
    ## Temperature          0   107
    ## ECSurfacePreTow      0   220
    ## ECBottomPreTow       0 13685
    ## CBVolume             0     0
    ## ACARTELA             0     0
    ## ACARTIA              0     0
    ## DIAPTOM              0     0
    ## EURYTEM              0     0
    ## OTHCALAD             0     0
    ## PDIAPFOR             0     0
    ## PDIAPMAR             0     0
    ## SINOCAL              0     0
    ## TORTANUS             0     0
    ## ALLCALADULTS         0     0
    ## AVERNAL              0     0
    ## LIMNOSPP             0     0
    ## LIMNOSINE            0     0
    ## LIMNOTET             0     0
    ## OITHDAV              0     0
    ## OITHSIM              0     0
    ## OITHSPP              0     0
    ## OTHCYCAD             0     0
    ## ALLCYCADULTS         0     0
    ## HARPACT              0     0
    ## CALJUV               0     0
    ## EURYJUV              0     0
    ## OTHCALJUV            0     0
    ## PDIAPJUV             0     0
    ## SINOCALJUV           0     0
    ## ASINEJUV             0     0
    ## ACARJUV              0     0
    ## DIAPTJUV             0     0
    ## TORTJUV              0     0
    ## ALLCALJUV            0     0
    ## CYCJUV               0     0
    ## LIMNOJUV             0     0
    ## OITHJUV              0     0
    ## OTHCYCJUV            0     0
    ## ALLCYCJUV            0     0
    ## COPNAUP              0     0
    ## EURYNAUP             0     0
    ## OTHCOPNAUP           0     0
    ## PDIAPNAUP            0     0
    ## SINONAUP             0     0
    ## ALLCOPNAUP           0     0
    ## BOSMINA              0     0
    ## DAPHNIA              0     0
    ## DIAPHAN              0     0
    ## OTHCLADO             0     0
    ## ALLCLADOCERA         0     0
    ## ASPLANCH             0     0
    ## KERATELA             0     0
    ## OTHROT               0     0
    ## POLYARTH             0     0
    ## SYNCH                0     0
    ## SYNCHBIC             0     0
    ## TRICHO               0     0
    ## ALLROTIFERS          0     0
    ## BARNNAUP             0     0
    ## CRABZOEA             0     0

You’ll want to develop other data-checking and (or) data-cleaning
procedures as needed. For now , we’ll suffice at checking `NA`s.

# Questions (from `applyfunctions.Rmd`)

#### What is the average CPUE of each species?

The first step to answering this question is which field or fields
contain CPUE (catch-per-unit-effort)?

A call to `base::colnames` reveals each species is a field. Are data are
in “wide” format. We also see species field names are all CAPS. This can
play to our advantage, as R is case sensitive.

*Note*: we assume data in each species field are CPUE.

``` r
colnames(CBdata)
```

    ##  [1] "SurveyCode"      "Year"            "Survey"          "SurveyRep"      
    ##  [5] "Date"            "Station"         "EZStation"       "DWRStation"     
    ##  [9] "Core"            "Time"            "TideCode"        "Region"         
    ## [13] "Secchi"          "Chl.a"           "Temperature"     "ECSurfacePreTow"
    ## [17] "ECBottomPreTow"  "CBVolume"        "ACARTELA"        "ACARTIA"        
    ## [21] "DIAPTOM"         "EURYTEM"         "OTHCALAD"        "PDIAPFOR"       
    ## [25] "PDIAPMAR"        "SINOCAL"         "TORTANUS"        "ALLCALADULTS"   
    ## [29] "AVERNAL"         "LIMNOSPP"        "LIMNOSINE"       "LIMNOTET"       
    ## [33] "OITHDAV"         "OITHSIM"         "OITHSPP"         "OTHCYCAD"       
    ## [37] "ALLCYCADULTS"    "HARPACT"         "CALJUV"          "EURYJUV"        
    ## [41] "OTHCALJUV"       "PDIAPJUV"        "SINOCALJUV"      "ASINEJUV"       
    ## [45] "ACARJUV"         "DIAPTJUV"        "TORTJUV"         "ALLCALJUV"      
    ## [49] "CYCJUV"          "LIMNOJUV"        "OITHJUV"         "OTHCYCJUV"      
    ## [53] "ALLCYCJUV"       "COPNAUP"         "EURYNAUP"        "OTHCOPNAUP"     
    ## [57] "PDIAPNAUP"       "SINONAUP"        "ALLCOPNAUP"      "BOSMINA"        
    ## [61] "DAPHNIA"         "DIAPHAN"         "OTHCLADO"        "ALLCLADOCERA"   
    ## [65] "ASPLANCH"        "KERATELA"        "OTHROT"          "POLYARTH"       
    ## [69] "SYNCH"           "SYNCHBIC"        "TRICHO"          "ALLROTIFERS"    
    ## [73] "BARNNAUP"        "CRABZOEA"

A call to `base::grepl` using `pattern = "[A-Z]$"` (i.e., checking for
capital letters from the text end) yields `TRUE` for all species field
names.

``` r
# `b` for Boolean
b <- grepl(pattern = "[A-Z]$", x = colnames(CBdata))

sum(b)
```

    ## [1] 56

``` r
# just for easier observartion (run as desired)
# cbind(colnames(CBdata), b)
# or...
# View(cbind(colnames(CBdata), b), title = "SpeciesFieldCheck")
```

Verify for yourself there are in fact 56 species. Now to answer our
question…simply call `base::colMeans` on the subsetted `CBdata`. Play
with display format as desired (e.g., call `as.data.frame` on the
`colMeans` output).

``` r
colMeans(CBdata[b])
```

    ##     ACARTELA      ACARTIA      DIAPTOM      EURYTEM     OTHCALAD     PDIAPFOR 
    ## 3.722963e+01 6.370312e+02 2.962249e+01 5.027960e+02 9.075370e+00 3.420889e+02 
    ##     PDIAPMAR      SINOCAL     TORTANUS ALLCALADULTS      AVERNAL     LIMNOSPP 
    ## 3.668395e+00 2.732232e+02 4.171143e+00 1.838906e+03 9.480756e+01 4.205954e+01 
    ##    LIMNOSINE     LIMNOTET      OITHDAV      OITHSIM      OITHSPP     OTHCYCAD 
    ## 7.491748e-01 3.429497e+01 8.534843e+01 1.107910e+00 1.016324e-03 7.636286e+01 
    ## ALLCYCADULTS      HARPACT       CALJUV      EURYJUV    OTHCALJUV     PDIAPJUV 
    ## 3.347309e+02 1.091402e+02 1.182177e+03 9.921408e+01 8.694168e+01 4.822276e+02 
    ##   SINOCALJUV     ASINEJUV      ACARJUV     DIAPTJUV      TORTJUV    ALLCALJUV 
    ## 2.887755e+01 7.978477e+00 4.304445e+01 3.652696e-01 4.098201e+00 1.934924e+03 
    ##       CYCJUV     LIMNOJUV      OITHJUV    OTHCYCJUV    ALLCYCJUV      COPNAUP 
    ## 4.468086e+02 6.663318e+00 1.317224e+00 6.303966e+01 5.178287e+02 4.342833e+02 
    ##     EURYNAUP   OTHCOPNAUP    PDIAPNAUP     SINONAUP   ALLCOPNAUP      BOSMINA 
    ## 5.538607e+00 1.273359e+02 6.865348e+01 7.185538e+00 6.429970e+02 1.223635e+03 
    ##      DAPHNIA      DIAPHAN     OTHCLADO ALLCLADOCERA     ASPLANCH     KERATELA 
    ## 2.635369e+02 1.341195e+02 1.667525e+02 1.788044e+03 9.558877e+01 3.330848e+01 
    ##       OTHROT     POLYARTH        SYNCH     SYNCHBIC       TRICHO  ALLROTIFERS 
    ## 1.084986e+03 1.446797e+01 1.228513e+02 3.489711e+00 1.334192e+01 1.368034e+03 
    ##     BARNNAUP     CRABZOEA 
    ## 8.163137e+02 6.966340e+00

#### What is the maximum CPUE of Eurytemora in Suisun Bay by year?

Here we get a bit specific. We seek annual maximum CPUE for only
Eurytemora in Suisun Bay. Our “filter” is Suisun Bay, and our “split” is
by year. *Note*: for this purpose, we assume `EURYTEM` is the desired
field.

``` r
eurytem_year <- split(CBdata[c("Region", "EURYTEM")], f = CBdata["Year"])
```

Because, variable `eurytem_year` is a list, we can use `vapply` to loop
through each year. Each element in `eurytem_year` is a data.frame with
two fields: `Region` & `EURYTEM`. Our anonymous function has one
parameter: `d` (short for data).

  - `b <- d[["Region"]] %in% "SuiBay"` is our “filter” selecting only
    `SuiBay` (we assume Suisun Bay)
  - `max(d[b, "EURYTEM"])` returns the maximum value — a single numeric
    — on the subsetted data (just to be safe you could include `,
    na.rm = TRUE` but we know from our clean data check no `NA`s exist
    in our species fields)

Output below can be assigned to a variable, and then plotted if desired.

``` r
vapply(eurytem_year, FUN = function(d) {
  b <- d[["Region"]] %in% "SuiBay"
  max(d[b, "EURYTEM"])
}, FUN.VALUE = numeric(1L))
```

    ##    1972    1973    1974    1975    1976    1977    1978    1979    1980    1981 
    ## 26531.1 21090.2 40541.8 15860.3 18455.9  2311.3 24569.6 13137.0 16365.6 10582.1 
    ##    1982    1983    1984    1985    1986    1987    1988    1989    1990    1991 
    ## 19384.5 21134.9 10942.9  5601.5 11790.1  3093.2   133.5   205.7   220.1   325.7 
    ##    1992    1993    1994    1995    1996    1997    1998    1999    2000    2001 
    ##   286.5  1244.2    28.1   206.1   145.8   487.9   204.0   951.8   254.2   314.8 
    ##    2002    2003    2004    2005    2006    2007    2008    2009    2010    2011 
    ##   202.1   324.1   186.4   303.7   313.8   128.7   453.2   262.6   535.7   756.0 
    ##    2012    2013    2014    2015    2016    2017    2018 
    ##   310.9   174.2   189.6    56.0   470.5   433.4   410.0

#### Calculate the relative % composition of each species by year (this is a hard one).

We assume we are to use CPUE values (i.e., in our wide format, each
species column).

**Step 1**: `split` all species data by year. Recall our variable `b`,
which gave `TRUE` for field names with all caps (i.e., species names).

``` r
species_year <- split(CBdata[b], f = CBdata[["Year"]])
```

Now each element in list `species_year` represents a year. Run
`str(species_year[["2018"]])` as an example to verify this element is a
dataframe with 56 variables. Try other years, too, if you wish.

**Step 2**: Each row in the data.frame (either `CBdata` or
`species_year`) represents a sampling event (i.e, date-station-tow). If
we sum each species (i.e., each column), we get the yearly total. So
here we need a call to `base::colSums`. Below works, but we need
“relative % composition”.

``` r
species_year_total <- t(
  vapply(species_year, FUN = colSums, FUN.VALUE = numeric(sum(b)))
)
```

**Step 3**: A call to `base::prop.table` should do the trick. `margin
= 1` indicates by rows (i.e., by year). *Note*: If not using a call to
`t` like above, then set `margin = 2` for columns.

``` r
rel_percent_comp <- prop.table(species_year_total, margin = 1)

# double-check rows should sum to 1
# rowSums(rel_percent_comp)

# for ease of viewing rather than in the console
# View(rel_percent_comp)
```

# Questions (from `data mainpulaton.Rmd`)

Here, we will continue to use data.frame `CBdata`.

#### How many samples does the Zooplankton survey have from the North Delta that contain Harpacticoids (HARPACT)?

A call to `base::table` on field `Region` returns 700+ records North
Delta (we assume `NorDel` = North Delta). Further, we display CPUE range
for our desired zooplankton (`HARPACT`).

``` r
table(CBdata[["Region"]], useNA = "ifany")
```

    ## 
    ## CarStrait   EastDel        EZ     NapaR     NEDel    NorDel      SacR       SJR 
    ##       819      1586       468         5       465       738      1476      4890 
    ##     SoDel     SPBay    SuiBay    SuiMar   WestDel 
    ##      1811       578      5899      1555      1947

``` r
range(CBdata[["HARPACT"]])
```

    ## [1]     0.0 40420.5

We can answer the question using Boolean values.
<code>CBdata\[\[“HARPACT”\]\] \> 0</code> returns `TRUE` for all
samples with `HARPACT`, and `CBdata[["Region"]] %in% "NorDel"` returns
`TRUE` for all North Delta samples. We want the count of records
(samples) when both are `TRUE`. Because `TRUE` = 1 and `FALSE` = 0,
summing the result should give us the number we desire. *Note*: we
assume each row in `CBdata` is a sample.

``` r
sum(CBdata[["HARPACT"]] > 0 & CBdata[["Region"]] %in% "NorDel")
```

    ## [1] 471

Our result should be less than the `NorDel` value in the `table` result
above.

#### Make a new variable for the total catch of all zooplankton.

Recall our variable `b`, which selects all zooplankton (species) fields
in `CBdata`.

``` r
total_species_catch <- sum(CBdata[b])

# display
total_species_catch
```

    ## [1] 395448354

``` r
# or with formatting possibilities
format(total_species_catch, big.mark = ",")
```

    ## [1] "395,448,354"

``` r
format(total_species_catch, digits = 3, scientific = TRUE)
```

    ## [1] "3.95e+08"

#### Create a new data frame that only contains samples with positive occurances of Eurytemora (EURYTEM).

We need a filter (only possitive occurences) and field selection (all
non-species fields + `EURYTEM`). If variable `b` selects for all
zooplankton fields, then `!b` is everything else.

``` r
# create our desired fields
# we assume the only zooplankton field we want is EURYTEM
fields <- c(colnames(CBdata)[!b], "EURYTEM")

fields
```

    ##  [1] "SurveyCode"      "Year"            "Survey"          "SurveyRep"      
    ##  [5] "Date"            "Station"         "EZStation"       "DWRStation"     
    ##  [9] "Core"            "Time"            "TideCode"        "Region"         
    ## [13] "Secchi"          "Chl.a"           "Temperature"     "ECSurfacePreTow"
    ## [17] "ECBottomPreTow"  "CBVolume"        "EURYTEM"

``` r
# our filter: CBdata[["EURYTEM"]] > 0

eurytem_catch <- CBdata[CBdata[["EURYTEM"]] > 0, fields]

dim(eurytem_catch)
```

    ## [1] 12691    19

``` r
colnames(eurytem_catch)
```

    ##  [1] "SurveyCode"      "Year"            "Survey"          "SurveyRep"      
    ##  [5] "Date"            "Station"         "EZStation"       "DWRStation"     
    ##  [9] "Core"            "Time"            "TideCode"        "Region"         
    ## [13] "Secchi"          "Chl.a"           "Temperature"     "ECSurfacePreTow"
    ## [17] "ECBottomPreTow"  "CBVolume"        "EURYTEM"

``` r
range(eurytem_catch[["EURYTEM"]])
```

    ## [1]     0.1 40541.8

-----

run: March 04 2020 @ 1303  
© IEP educational series
