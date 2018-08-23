

#___________________________________________________________________________
#
#         ___  2
#         |__) 
#         |  \    R Training Session II   
#
#___________________________________________________________________________



# R Studio Projects -------------------------------------------------------
# R Studio projects are a great feature which allow you to have one dedicated session for each project you are working on
# One of the great features is that it sets the working directory to the project folder automatically so others can easily
# work off the same file without having to adjust their file paths (and everything is step up the exact same).
# To start an R Project that already exists, double click on the .Rproj file in the folder.
# If you have not opened this session via the .Rproj file, you will need to so that all the file paths work the same on your machine



# Every time you open R, you will need to "open" or load your packages, using library()
library(tidyverse)


#--------------------------------------------------------------
# ---- (0) Importing the dataset ----- 
#--------------------------------------------------------------
# Pulling in the dataset for next steps
df <- read_tsv("RawData/ex2_data.txt",
                      col_types = cols(MechanismID      = "c",
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
spec(df)
View(slice (df, 1:20))





#--------------------------------------------------------------
# ---- (1) Creating New Variables (Mutate) ----- 
#--------------------------------------------------------------


# Dividing FY2017APR values by 10
df2 <- mutate(df, FY2017APR_true = FY2017APR/10)
View (select(df2, FY2017APR, FY2017APR_true))

# Above step AND doubling the FY18 Q2 values
df2 <- mutate(df, FY2017APR_true = FY2017APR/10, FY2018Q2_true = FY2018Q2 *2) 
View (select(df2, FY2017APR, FY2017APR_true, FY2018Q2, FY2018Q2_true))


# New Partner Names, one change
# mutate() and if_else() make for a powerful combination in tandem.
# if_else function is comprable to IF function in excel 

View(count(df, PrimePartner)) # view this variable
df3 <- mutate(df, newpartnername = 
                if_else(PrimePartner == "Stark", "OnlySansaStark", PrimePartner))
View(count(df3, PrimePartner, newpartnername))


# New Partner Names, multiple changes. 
df4 <- mutate(df, newpartnername = 
                if_else(PrimePartner == "Stark", "Ned's Family", 
                        if_else(PrimePartner == "First Men", "First Men & Women", 
                                if_else(PrimePartner == "Ice" , "Ice & Fire", PrimePartner))))
View(count(df4, PrimePartner, newpartnername))


# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 1. Create a new dataset called test1 from "df" and
# create a new variable called "newvar", which will change the PSNU value "The Iron Islands" to "Charmin Islands"
# 1a. Using count, view the PSNU column in dataset test1 





#----------------------------------------------------------------------
# ---- (2) Piping %>%  - Bringing It All Together ----- 
#----------------------------------------------------------------------


# Pipes let you take the output of one function and send it directly to the next, 
# which is useful when you need to do many things to the same dataset

# %>% returns an object, you can actually allow the calls to be 
# chained together in a single statement, without needing variables 
# to store the intermediate results.



# Examples:
# Positives found by Total Numerator:
hts1 <- df %>%   # this is the pipe! goes at end of every function statement 
  filter(indicator == "HTS_TST_POS" & standardizedDisaggregate == "Total Numerator") %>%
  select (OperatingUnit, indicator, PSNU, PrimePartner, FundingAgency, FY2018Q1, FY2017APR)

View(slice(hts1, 1:20))


# Same example Without Piping:
# you have to create several intermediate datasets, which is inefficient 
hts_nopipe <- filter (df, indicator == "HTS_TST_POS" & standardizedDisaggregate == "Total Numerator")
hts_nopipe2 <- select(hts_nopipe, OperatingUnit, indicator, PSNU, PrimePartner, FundingAgency, FY2018Q1, FY2017APR)

View(slice(hts_nopipe2, 1:20))



# New on treatment by OU and disagg type
tx2 <- df %>%
  filter(indicator == "TX_NEW" & FY2017APR >0 ) %>%
  rename (disagg_type = standardizedDisaggregate ) %>% 
  select (OperatingUnit, indicator, PSNU, disagg_type, FY2017APR)

View(count(tx2, disagg_type, FY2017APR))



tx3 <- df %>% 
  filter((indicator == "TX_CURR" | indicator == "TX_NEW" | indicator == "HTS_TST") & standardizedDisaggregate == "Total Numerator") %>%
  mutate (newpartnername = if_else(PrimePartner == "Great Houses", "Castles and Mansions", PrimePartner)) %>% 
  select (OperatingUnit, SNU1, SNUPrioritization, PSNU, newpartnername, indicator, standardizedDisaggregate, FY2017APR) %>%
  arrange (newpartnername) %>%
  rename (disagg_type = standardizedDisaggregate) 

View(tx3)
View(count(tx3, newpartnername, indicator, disagg_type))


# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 2. Please create a new dataset, "test2" from "df" where you pipe these steps together:
# filter for TX_NEW
# select OperatingUnit, PSNU, FY2018Q2
# arrange PSNU
# then View it



#----------------------------------------------------------------------
# ---- (3) Summarizing Data  ----- 
#----------------------------------------------------------------------

# now that we know about piping.....
# most of our work involves trying to aggregate or roll things up, similar to pivot tables
# let's try to look at our SNU1 level of TX_NEW results from FY2017
# We can use the summarise commands to aggregate our data

df %>% 
  summarise(FY2017APR = sum(FY2017APR, na.rm = TRUE ))
# this give us a single line for the whole country and all indicators; let's filter
df %>% 
  filter(indicator == "TX_NEW", standardizedDisaggregate == "Total Numerator") %>% 
  summarise(FY2017APR = sum(FY2017APR, na.rm = TRUE ))
# that's better but we want to look at the APR results across SNUs, so we need to use a group_by command 
# (which should follow by ungroup so we don't perform any other calculations across this group)
df %>% 
  filter(indicator == "TX_NEW", standardizedDisaggregate == "Total Numerator") %>% 
  group_by(OperatingUnit, SNU1) %>% 
  summarise(FY2017APR = sum(FY2017APR, na.rm = TRUE )) %>% 
  ungroup()  # it is important to ungroup after using group_by as R data objects retain the grouping internally
             # this will lead to errors if later you try to create a new variable




# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 3. create a new dataset, called test3 from df where you:
# filter for TX_CURR and Total Numerator 
# summarise FY2017APR 
# and group_by PSNU
# then View it




#--------------------------------------------------------------
# ---- (4) Renaming Variables (Rename) ----- 
#--------------------------------------------------------------

View (slice(df, 1:20)) #seeing what is there currently

# like all R assignments, the new variable is on the left side of argument
df7 <- rename(df, Partner = PrimePartner, Agency = FundingAgency)

View(df7) # you will see new names in column headers

# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 4. Please create a new dataset called test4 from df and rename SNU1 to EssEnYouOne
# then view it 





#--------------------------------------------------------------
# ---- (5) Deleting Variables ----- 
#--------------------------------------------------------------

View (slice(df6, 1:20))

# Let's remove UIDs
df8 <- select(df7 ,-RegionUID, -OperatingUnitUID, -SNU1UID, -PSNUuid, -MechanismUID)

View (slice(df7, 1:20))


# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:


# 5. Please create a new dataset, called test5 from df and delete RegionUID & OperatingUnitUID
# then view it




#----------------------------------------------------------------------
# ---- (6) Stacking Datasets  ----- 
#----------------------------------------------------------------------


         
# Use rbind function to stack or merge datasets by rows 

df_double <- bind_rows(df, na_df)


# If one dataset has variables that the other dataset does not, then bind_rows will
# Assigns "NA" to those rows of columns missing in one of the data frames 

df_double2 <- bind_rows(df5, na_df)
View(arrange(df_double2, desc(FY18CUM)))










