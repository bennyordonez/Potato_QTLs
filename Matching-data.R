## To see where are you
getwd()
setwd("/Users/bordonez/Documents/BackupCIP/QTLs")

## Installed and read libraries
library(tidyverse)
library(plyr)
library(dplyr)
install.packages("nycflights13")
library(nycflights13)
library(readr)

## Reading data. GraList_Markers is the file comprising the full list of markers. DMDD_M and DMDD_P are both the files corresponding with each map.
GraList_Markers <- read_csv("~/Documents/backupCIP/QTLs/GraList-Markers.csv")
DMDD_M <- read.csv("~/Documents/backupCIP/QTLs/DMDD-M.csv", header = TRUE)
DMDD_P <- read.csv("~/Documents/backupCIP/QTLs/DMDD-P.csv", header = TRUE)

### Curating data on DMDD-M

## In some cases, the "locus ID" shows only a part of the name of the "Locus ID" in the DMDD_M
DMDD_M$Locus_ID 
grep("^PM", DMDD_M$Locus_ID, value = T) 
grep("^pPt", DMDD_M$Locus_ID, value = T)
tmp <- grep("^pPt|^PM", DMDD_M$Locus_ID)

## Keep only the ID that is present in both dataframes
DMDD_M$Locus_ID <- gsub("(PM)([[:digit:]]+)(_)([[:digit:]]+)", "\\1\\2", DMDD_M$Locus_ID)
DMDD_M$Locus_ID <- gsub("(pPt)(-)([[:digit:]]+)", "\\3", DMDD_M$Locus_ID)
## showing that the function is working
DMDD_M$Locus_ID[tmp]

### Curating data on GraList_Markers
# In some cases, the locus ID shows the complet name of the Locus in the GraList_Markers
grep("solcap",GraList_Markers$Locus_ID, value = T)
oth <- grep ("solcap", GraList_Markers$Locus_ID)
oth

### Keep only the ID that is present in both dataframes
GraList_Markers$Locus_ID <- gsub("(solcap)(_)(stsnp)(_)(c1)(_)([[:digit:]]+)", "\\3\\4\\5\\6\\7", GraList_Markers$Locus_ID)
## showing that the function is working
GraList_Markers$Locus_ID[oth]

##Apply left join to the curate dataframes, meaning between GraList_Markers and DMDD_M

#Compare two data frame to find cases where "Locus ID" is the same in both cases.
# looking for overlaps between your marker set and the data table which have the genetic position information and combine both tables into a single one. 
benny_M <- left_join(GraList_Markers,DMDD_M, by='Locus_ID')

# Show only matched cases (Taking out the NA values)
BennyOnlyMactchM <- benny_M[is.na(benny_M$X.Individual..) == FALSE, ]

#Check how many cases have been matched in your curate data of DMDD_M
dim(BennyOnlyMactchM)
# See your curate and merge file. 
View(BennyOnlyMactchM)

###Curating data on DMDD_P
##In some cases, the locus ID shows a part of the name of the Locus in the DMDD_P
DMDD_P$Locus_ID 
grep("^PM", DMDD_P$Locus_ID, value = T) 
grep("^toPt", DMDD_P$Locus_ID, value = T)
grep("^pPt", DMDD_P$Locus_ID, value = T)
slv <- grep("^PM|^toPt|^pPt", DMDD_P$Locus_ID)

#Keep only the ID that is present in both dataframes
DMDD_P$Locus_ID <- gsub("(PM)([[:digit:]]+)(_)([[:digit:]]+)", "\\1\\2", DMDD_P$Locus_ID)
DMDD_P$Locus_ID <- gsub("(toPt)(-)([[:digit:]]+)", "\\3", DMDD_P$Locus_ID)
DMDD_P$Locus_ID <- gsub("(pPt)(-)([[:digit:]]+)", "\\3", DMDD_P$Locus_ID)

#showing that the function is working
DMDD_P$Locus_ID[slv]

##Apply left join to the curate dataframes, meaning between GraList_Markers and DMDD_P

##Compare two data frame to find cases where "Locus ID" is the same in both cases.
## looking for overlaps between your marker set and the data table which have the genetic position information and combine both tables into a single one. 
benny_P <- left_join(GraList_Markers,DMDD_P, by='Locus_ID')

##Show only matched cases, meaning, Taking out the NA values
BennyOnlyMactchP <- benny_P[is.na(benny_P$X.Individual..) == FALSE, ]

##Check how many cases have been matched in your curate data of DMDD_M
dim(BennyOnlyMactchP)
View(BennyOnlyMactchP)

## Save the files in your folder
save(BennyOnlyMactchM, file ="/Users/bordonez/Documents/BackupCIP/QTLs/BennyOnlyMactchM.Rdata")
save(BennyOnlyMactchP, file ="/Users/bordonez/Documents/BackupCIP/QTLs/BennyOnlyMactchP.Rdata")

