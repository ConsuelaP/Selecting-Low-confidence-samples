####################################################################################################
####################################################################################################
## Prepare data for revision
## Contact remi.dannunzio@fao.org
## 2016/12/21 -- Suriname
####################################################################################################
####################################################################################################
options(stringsAsFactors=FALSE)

library(Hmisc)
library(sp)
library(rgdal)
library(raster)
library(plyr)
library(foreign)

#######################################################################
##############################     SETUP YOUR DATA 
#######################################################################

#test


#test2

## Set your working directory
setwd("A:/WORK/WORKFOLDER/Goldmining update 2015/QAQC/QAQC_Ass")

## Read the datafile and setup the correct names for the variables
pts_ce_ouput <- read.csv("results/collectedData_earthsae_CE_2017-06-05_final_on_060617_152905_CSV_CP_CK.csv")

## Read the datafile with the original point for reading in Collect Earth
pts_ce_input <- read.csv("data/sae_design_GMS_2014_2015_Buffer_merge_diss_single/pts_CE_2017-06-05_final.csv")

names(pts_ce_ouput)

## Subsetting the low confidence with agreement for revision
out2 <- pts_ce_input[
  pts_ce_input$ID %in% pts_ce_ouput[
    (pts_ce_ouput$confidence == "lo") 
    & 
      (pts_ce_ouput$ref_class == pts_ce_ouput$map_class)
    ,
    ]$id,
  ]

check2 <- pts_ce_ouput[pts_ce_ouput$id %in% out2$ID,c("id","map_class","ref_class","operator")]

table(check2$operator,check2$map_class)


## Export as csv file
write.csv(out2,paste("ce_input/revise_lo_20170607.csv",sep=""),row.names=F)


## Subsetting the original input file with criterias from the preliminary results (omissions and commissions)
out <- pts_ce_input[
  pts_ce_input$ID %in% pts_ce_ouput[
    (
      (pts_ce_ouput$map_class  == "DEFOR_00_09" & pts_ce_ouput$confidence == "hi") 
      & 
      (pts_ce_ouput$ref_class  %in% c("FOREST","HYDRO","NON_FOREST"))
      )
    | 
      (
        (pts_ce_ouput$map_class  == "DEFOR_09_15" & pts_ce_ouput$confidence == "hi") 
        & 
          (pts_ce_ouput$ref_class  %in% c("FOREST","HYDRO","NON_FOREST"))
      )
    ,
    ]$id,
  ]

(check <- pts_ce_ouput[pts_ce_ouput$id %in% out$ID,c("id","map_class","ref_class")])

## Export as csv file
write.csv(out,paste("results_20161222/revise_overest_20161223.csv",sep=""),row.names=F)

