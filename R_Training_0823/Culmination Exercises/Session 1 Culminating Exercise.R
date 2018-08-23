
#------- Session 1 Culminating Exercise ----------
#-------------------------------------------------

# This exercise is intended for you to do indepdently after the Session 1 lesson.
# This exercise will integrate all of the methods gained from Session 1 into a 
#   simulation of analyses you may do in real life using MER data 


# Question 1: You just joined the field team of the OU, Essos, in PEPFAR. 
# They have expressed interest in having a readily available dataset that just contains their OU's data.
# They also want to keep only TX_NEW, HTS_TST, HTS_TST_POS and TX_CURR, all disaggregates.
# Using the ex1_data dataset in the R training folder, please use it to satisfy the conditions above. Explore the dataset as well. 



# Question 2: Now that you have prepared this dataset, the Branch Chief wants this dataset to be exported as a .csv file so the team can use it.
# Before you do that, she also wants to know how big the datasets, namely, # of rows and variables. 
# When ready, export into the output subfolder of your R Training folder, and call the file, Essos1




# Question 3: After using the dataset, Essos1, your branch chief wants a leaner dataset since she is not interested in all of the variables. 
# She wants to create a dataset that only has Region, OperatingUnit, PSNU, indidcator, PrimePartner, FundingAgency, standardidzedDisaggregate, and all FY2018 quarters
# She also wants this dataset to have only CDC and USAID data. View the data to know what to filter for. 
# Use Essos1.csv from Question 2 as your starting point(or test2), and create and export a dataset called Essos2 that satisfies the above conditions. 
# Explore the dataset as well.



# Question 4: You are being asked to prepare slides to present to Amb. Birx upon her arrival to Essos. 
# She wants two tables, one table where you show the total number of Positives identified and another where you show total number currently on TX in Fy18Q1.
# She wants the total numerator in both cases and she wants to see the table sorted by PSNU.
# She wants PSNU & FundingAgency in the table.   
# This will not be exported. Use the test2/Essos1.csv dataset. 









#---------------------------------ANSWERS-------------------------------#

# Question 1

library(tidyverse)

test <- read_tsv("RawData/ex1_data.txt",
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

spec(test)
glimpse(test)


test2 <- filter(test, OperatingUnit == "Essos", 
                indicator == "HTS_TST" | indicator == "HTS_TST_POS" | indicator == "TX_CURR" | indicator == "TX_NEW")

View(test2)
View(count(test2, OperatingUnit, indicator))



# Question 2

glimpse(test2)
write_csv (test2, path = "Output/Essos1.csv")


# Question 3


test3 <- read_csv("Output/Essos1.csv",
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

test4 <- filter(test3, FundingAgency == "HHS/CDC" | FundingAgency == "USAID")
test5 <- select(test4, Region, OperatingUnit, PSNU, indicator, PrimePartner, FundingAgency, standardizedDisaggregate, FY2018Q1, FY2018Q2)


View(test5)

write_csv (test5, path = "Output/Essos2.csv")


# Question 4

test_hts <- filter(test2, indicator == "HTS_TST_POS", standardizedDisaggregate == "Total Numerator")
View(count(test_hts, OperatingUnit, PSNU, FundingAgency, indicator, wt = FY2018Q1, sort = TRUE))

test_tx <- filter(test2, indicator == "TX_CURR", standardizedDisaggregate == "Total Numerator")
View(count(test_tx, OperatingUnit, PSNU, FundingAgency, indicator, wt = FY2018Q1, sort = TRUE))




