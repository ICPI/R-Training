
#___________________________________________________________________________
#~~~~~~~~~~~      _____   _             _       _                ~~~~~~~~~~~~~~~
#~~~~~~~~~~~     |  __ \ | |           (_)     (_)               ~~~~~~~~~~~~~~~ 
#~~~~~~~~~~~     | |__) || |_ _ __ __ _ _ _ __  _ _ __   __ _    ~~~~~~~~~~~~~~~
#~~~~~~~~~~~     |  _  / | __| '__/ _` | | '_ \| | '_ \ / _` |   ~~~~~~~~~~~~~~~
#~~~~~~~~~~~     | | \ \ | |_| | | (_| | | | | | | | | | (_| |   ~~~~~~~~~~~~~~~
#~~~~~~~~~~~     |_|  \_\ \__|_|  \__,_|_|_| |_|_|_| |_|\__, |   ~~~~~~~~~~~~~~~
#~~~~~~~~~~~           ______                            __/ |   ~~~~~~~~~~~~~~~
#~~~~~~~~~~~          |______|                           \___/   ~~~~~~~~~~~~~~~
#___________________________________________________________________________


# R Studio Projects -------------------------------------------------------
# R Studio projects are a great feature which allow you to have one dedicated session for each project you are working on
# One of the great features is that it sets the working directory to the project folder automatically so others can easily
# work off the same file without having to adjust their file paths (and everything is step up the exact same).
# To start an R Project that already exists, double click on the .Rproj file in the folder.
# If you have not opened this session via the .Rproj file, you will need to so that all the file paths work the same on your machine





#-------------------------------------------------------
# ---- (0) Loading Tidyverse Package (Slide )----- 
#--------------------------------------------------------
# R is built of packages that have to be independently installed the first time you use them, install.packages()
install.packages("tidyverse")
# Every time you open R, you will need to "open" or load your packages, using library()
library(tidyverse)

# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

#Please load the tidyverse package







#-------------------------------------------------------
# ---- (1) Importing TXT datafile ----- 
#--------------------------------------------------------
# function used is 'read_tsv' & its arguments (file path and/or name), 
# reads in txt file named "ex1_data.txt", and stores dataset as an object named 'txt' 
# object <- function(relative file path/filename.txt)


# Getting HELP  
?read_tsv
help("read_tsv")
 


# Relative folder paths
# Subfolder in project - dependent on setting the working directory properly  
txt <- read_tsv("RawData/ex1_data.txt")


# Specifying the type of each variable being pulled in
# This is really important since R reads in the first 1000 lines and then guesses what the column type is
# If you don't have any targets data in the first 1000 lines for example, it will be read in as string

#             "c" = character 
#             "i" = integer 
#             "n" = number 
#             "d" = double (includes decimals)
#             "l" = logical 
#             "D" = date 
#             "T" = date time 
#             "t" = time 
#             "?" = guess


# Add customized variable types for accuracy
txt2 <- read_tsv(file = "RawData/ex1_data.txt", 
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


# Check your data classes for all variables
spec(txt2)



# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 1. Import your dataset (.txt file) and name it dataset1
# Feel free to copy and paste from lesson script






#-------------------------------------------------------
# ---- (2) Importing CSV datafile  ----- 
#--------------------------------------------------------
# function used is 'read_csv' & its arguments (file path and/or name), 
# reads in csv file named "ex1_data.csv", and stores dataset as an object named 'csv_df' 
# object <- function(relative file path/filename.csv)


# Add customized variable types for accuracy
csv2 <- read_csv (file = "RawData/ex1_data.csv", 
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
spec(csv2)



# Pulling dataset from online source
data_url <- "https://raw.githubusercontent.com/ICPI/TrainingDataset/master/Output/ICPI_MER_Structured_TRAINING_Dataset_PSNU_IM_FY17-18_20180515_v1_1.txt"
MSD <- read_tsv(data_url)
rm(data_url) #removes object



#-------------------------------------------------------
# ---- (3) Ways to View your dataset(s) ----- 
#--------------------------------------------------------
View(txt2)  # to see entire dataset
names(txt2) # to see variable names
spec(txt2)  # to see variable names and types
glimpse(txt2) #combines view of names, specs, and the first few rows of data



# View() allows you to see the entire dataset as we saw above
# you can narrow down that view by taking a "slice" of a number of rows and/or selecting certain columns
#look a the first 20 rows  

slice(txt2, 1:20)
View(slice(txt2, 1:20))



# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 2a. View your entire dataset1
# 2b View the names of all of your variables in your dataset1
# 2c. View the top 40 rows of dataset1 using the slice function






# look at the first 3 columns and first 20 columns
View(select(slice(txt2, 1:20), Region:OperatingUnit))


# The dplyr function, 'select' allows for specifiying any number of variables to retain and view.
select(txt2, OperatingUnit, PSNU, Region) #this gets cut off
View (select(txt2, OperatingUnit, PSNU, Region)) # to show all rows

# To retain variables that start with or end with a certain string pattern. 
select(txt2, ends_with("Q2"))
select(txt2, starts_with("FY2017"))

# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 2d Create a new dataframe called dataset2 and retain the following columns from dataset1 and view their data: 
# OperatingUnit, PSNU, Region, indicator. 








# The dplyr functions, 'distinct' and 'count' show a breakdown of a column's unique values. 
distinct(txt2, OperatingUnit)
count(txt2, OperatingUnit) # count gives you the values and the # of rows whereas distinct only displays values
count(txt2, Region, OperatingUnit, PSNU, SNU1)
View (count(txt2, Region, OperatingUnit, PSNU, SNU1)) 

#option to allow you to easily sort
count(txt2, OperatingUnit, sort = TRUE) 


#by adding in the weight, allows for easy aggregation, similar to pivot table "sum"
# 'n' now reports aggregate value for FY2018Q2 instead of # of rows
count(txt2, OperatingUnit, wt = FY2018Q2, sort = TRUE)


#when view is longer than 10 rows, use View()
count(txt2, Region, OperatingUnit, PSNU, SNU1, sort = TRUE)
View( count(txt2, Region, OperatingUnit, PSNU, SNU1, sort = TRUE))
View( count(txt2, Region, OperatingUnit, PSNU, SNU1, wt = FY2018Q2, sort = TRUE))


# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 2e View the number of unique values in your OperatingUnit column and in your PSNU columns for dataset2
# 2f do 2e, but add FY2017APR for the "wt" option and sort = TRUE as well  






# In Session 2, we will revisit Exploring the dataset
# we will look at a streamlined way to simulate looking at aggregate counts,
# which is very smiliar to pivot tables in excel
# This method will use the functions, group_by and summarise
  


#-------------------------------------------------------
# ---- (4) Sorting your dataset ----- 
#--------------------------------------------------------

# Sort variables using 'arrange' function from dplyr

# Sorting in ascending order (default) 
sorted <- arrange (txt2, PSNU)
select(sorted, PSNU)   # Doesn't display all rows
View(select(sorted, PSNU))   # Using 'View" shows all rows
View(count(sorted, PSNU))   #distinct PSNUs in order

# Sorting in descending order
sorted2 <- arrange(txt2, desc(PSNU))
View(select(sorted2, PSNU))
View(count(sorted2, PSNU)) # doesn't obey the sort


# Sorting multiple variables
sorted3 <- arrange(txt2, PSNU, indicator)
View(select(sorted3, PSNU, indicator))
View(count(sorted3, PSNU, indicator))

# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 2g Sort your dataset2 by ascending order for the following columns : OperatingUnit, PSNU, SNU1,
# Assign it the same name and View the dataset







#-------------------------------------------------------
# ---- (5) Subsetting your data  ----- 
#--------------------------------------------------------


#---- Subsetting for Columns (select) -----#

# Use dplyr 'Select' function to subset by variable(s)
geo_df <- select(txt2, OperatingUnit, SNU1, PSNU, FY2017APR)
names(geo_df)
View(geo_df)

# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:


#3a Subset dataset1 (from our first dataset) to include only the following variables:
# OperatingUnit, PSNU, SNU1, indicator, FY2018Q2 and name this new dataframe subset1





#---- Subsetting for Rows (filter) -----#

# filtering for one Indicator
hts <- filter(txt2, indicator =="HTS_TST")
# Ways to see if this worked
select(hts, indicator)
View (select(hts, indicator))
View (count(hts, indicator)) 


# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 3b Subset the dataframe named subset1 to include only data for Ethiopia and name this new dataframe ou





# filter for one indicator, (uses logical operator Not Equal) 
hts2 <- filter(txt2, indicator != "HTS_TST")
View (select (hts2, indicator))
View (count(hts2, indicator)) 


# filter for multiple indicators, (uses logical operator OR) 
hts3 <- filter(txt2, indicator == "HTS_TST" | indicator == "TX_NEW")
View (select (hts3, indicator))
View (count(hts3, indicator)) 


# filter for multiple conditions, (uses logical operator AND) 
hts4 <- filter(txt2, indicator == "HTS_TST", FY2017APR > 100)
View (select (hts4, indicator, FY2017APR))
View (count(hts4, indicator, FY2017APR)) 


# filter for multiple conditions, (uses multiple operators and multiple conditions) 
# Filtering for HTS_TST and TX_NEW total numerator values and its PSNUs
hts5 <- filter(txt2, indicator == "HTS_TST" | indicator == "TX_NEW", standardizedDisaggregate == "Total Numerator", FY2017APR > 100)
View (select (hts5, PSNU, indicator, standardizedDisaggregate, FY2017APR))
View (count(hts5, PSNU, indicator, standardizedDisaggregate, FY2017APR)) 


# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 3c Subset the dataframe named ou to include only data for indicators:
# HTS_TST, HTS_TST_POS and standardized disaggregate = Total Numerator. Name this new dataframe "hts"





#-------------------------------------------------------
# ---- (6) Cleaning your data ----- 
#--------------------------------------------------------
  # Removing values with 'NA' 
    # reading in the dataset with NA values in Sex
na_df <- read_tsv(file="RawData/na_data.txt", 
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
                                     FY2018_TARGETS     = "d"))


# Checking the data 
count(na_df, Sex)


# Removing N/A or other undesireable values and convert to 
  # True missing, or blank ""
 
na_df1 <- mutate(na_df, Sex = if_else(Sex == "N/A", "", Sex))  #converts to blanks
count(na_df1, Sex)

# when running models, true <NA> is treated as "missing"
# while blank "" is treated as another category for the variable
# Numeric variables will not accept "", but will have true <NA> only



#-------------------------------------------------------
# ---- (7) Exporting your data ----- 
#--------------------------------------------------------


write_tsv(hts4, path = "Output/exported_data.txt")

write_csv(hts4, path = "Output/exported_data.csv")


# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 4. Export your dataset, "hts"as a .txt file to the output folder in your R training folder. 
# Call it "exported2" in the path step









