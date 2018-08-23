# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

#0. Please load the tidyverse package

library (tidyverse)



# 1. Import the ex1_data.txt file and name it dataset1. 
# Feel free to copy and paste from lesson script

dataset1 <- read_tsv(file = "RawData/ex1_data.txt", 
                 col_types = cols(MechanismID        = "c",
                                  AgeAsEntered       = "c",            
                                  AgeFine            = "c",     
                                  AgeSemiFine        = "c",    
                                  AgeCoarse          = "c",      
                                  Sex                = "c",     
                                  resultStatus       = "c",     
                                  otherDisaggregate  = "c",     
                                  coarseDisaggregate = "c",     
                                  FY2017_TARGETS     = "d",
                                  FY2017Q1           = "d",      
                                  FY2017Q2           = "d",      
                                  FY2017Q3           = "d",      
                                  FY2017Q4           = "d",      
                                  FY2017APR          = "d",
                                  FY2018Q1           = "d",
                                  FY2018Q2           = "d",
                                  FY2018_TARGETS     = "d",
                                  FY2019_TARGETS     = "d"))



# 2a View your entire dataset1

View (dataset1)

# 2b View the names of all of your variables in your dataset1
names (dataset1)

# 2c. View the top 40 rows of dataset1 using the slice function

View(slice(dataset1, 1:20))

# 2d Create a new dataframe called dataset2 and retain the following columns from dataset1 and view their data: 
# OperatingUnit, PSNU, Region, indicator. 

dataset2 <- select(dataset1, OperatingUnit, PSNU, Region, Indicator)
View(select(dataset2, OperatingUnit, PSNU, Region, Indicator))


# 2e View the number of unique values in your OperatingUnit column and in your PSNU columns for dataset2

View(count(dataset2, OperatingUnit, PSNU))


# 2f Do 2e, but add FY2017APR for the "wt" option and sort as well  

View(count(dataset2, OperatingUnit, PSNU, wt = FY2017APR, sort = TRUE))


# 2g Sort your dataset2 by ascending order for the following columns : OperatingUnit, PSNU, SNU1
 # Assign it the same name and View the dataset

dataset2 <- arrange(dataset2, OperatingUnit, PSNU, SNU1)
View(dataset2)


#3a Subset data1 (from our first dataset) to include only the following variables:
# OperatingUnit, PSNU, SNU1, indicator, FY2018Q2 and name this new dataframe subset1

subset1 <- (select(dataset1, OperatingUnit, PSNU, SNU1, indicator, FY2018))


# 3b Subset the dataframe named subset1 to include only data for Ethiopia and name this new dataframe "ou"

ou <- filter(subset1, OperatingUnit == "Ethiopia")

# 3c Subset the dataframe named ou to include only data for indicators:
# HTS_TST, HTS_TST_POS and standardized disaggregate Total Numerator. Name this new dataframe "hts"

hts <- filter(subset1, indicator == "HTS_TST" | indicator == "HTS_TST_POS" , standardizedDisaggregate == "Total Numerator")


# 4. Export your dataset, "hts"as a .txt file to the output folder in your R training folder. 
# Call it "exported2" in the path step

write_tsv (hts, path = "Output/exported2_data.txt")







