#ERW 1-5-23
#Re-run this script with pfb from James for WRR RRC
#ERW 6-30-21
#Make new bargraph of precip for ARs, incl rain/snow partitioning
#Add timeseries of n-AR precip, incl rain/snow partitioning

library("MASS")
#library(ggplot2)
library(graphics)
#library(fields)
#rm(list=ls())

directory1 = "/global/cscratch1/sd/woodburn/hydro_of_ars_jan23/pfb_from_james"
setwd(directory1)
source("PFB-ReadFcn.R")

nx=667
ny=400
T_frz=273.66

#First load 1 pressure head to determine watershed mask
#Original used step1 but didn't have during RRC
#fin_mask=sprintf("/global/cscratch1/sd/fadji/Parflow01/Parflow/WRF-PF-year/dn7.out.press.00001.pfb") 	
fin_mask=sprintf("dn7.out.press.00000.pfb")
mask_temp=readpfb(fin_mask,F)

count_mask=0
mask=array(0,dim=c(667,400))
for (j in 1:ny)  {	
  for (i in 1:nx)  {
    if (mask_temp[i,j,1]>-3.402823e+38) {
      mask[i,j]=1
      count_mask=count_mask+1
    }
  }
}
count_mask
#count_mask=139433
#139433 or 52.2% cells

#Read in AR time periods -- only use first two columns of the 17 here
summary_data=array(0,c(10,17))
summary_data=read.csv(file="Summary_Table_AR_ERW.txt",header=FALSE,sep="\t")

precip_sum_all=array(0,dim=c(8760))
snowfall_sum_all=array(0,dim=c(8760))
rainfall_sum_all=array(0,dim=c(8760))

precip_sum_AR=array(0,dim=c(8760))
snowfall_sum_AR=array(0,dim=c(8760))
rainfall_sum_AR=array(0,dim=c(8760))

#Main time loop here
ar_count=1
for (t in 1:8753) {
  
  fin=sprintf("WRFd04.APCP.%06d.pfb",t) 	
  precip=readpfb(fin,F)
  
  fin_temp=sprintf("WRFd04.Temp.%06d.pfb",t)
  T_air=readpfb(fin_temp,F)
  
  for (j in 1:ny)  {	
    for (i in 1:nx)  {
      if (mask[i,j]==1) {	
 
        #First calc for all time periods
        
        precip_sum_all[t]=precip_sum_all[t]+precip[i,j,1]
        
        rainfall_incr=0
        snowfall_incr=0
        
        if (T_air[i,j,1]<T_frz){
          snowfall_sum_all[t]=snowfall_sum_all[t]+precip[i,j,1]
        }
        if ((T_air[i,j,1]>=T_frz)&&(T_air[i,j,1]<=(T_frz+2))){
          rainfall_incr=(-54.632+(0.2*T_air[i,j,1]))*precip[i,j,1]
          rainfall_sum_all[t]=rainfall_sum_all[t]+rainfall_incr
          snowfall_incr=precip[i,j,1]-rainfall_incr
          snowfall_sum_all[t]=snowfall_sum_all[t]+snowfall_incr
        }
        if (T_air[i,j,1]>T_frz+2){
          rainfall_sum_all[t]=rainfall_sum_all[t]+precip[i,j,1]
        }
        
        #Now do for AR
        if ((t>=summary_data[ar_count,1])&&(t<=summary_data[ar_count,2])&&(ar_count<=10)) {
          
          precip_sum_AR[t]=precip_sum_AR[t]+precip[i,j,1]
      
          rainfall_incr=0
          snowfall_incr=0
          
          if (T_air[i,j,1]<T_frz){
            snowfall_sum_AR[t]=snowfall_sum_AR[t]+precip[i,j,1]
          }
          if ((T_air[i,j,1]>=T_frz)&&(T_air[i,j,1]<=(T_frz+2))){
            rainfall_incr=(-54.632+(0.2*T_air[i,j,1]))*precip[i,j,1]
            rainfall_sum_AR[t]=rainfall_sum_AR[t]+rainfall_incr
            snowfall_incr=precip[i,j,1]-rainfall_incr
            snowfall_sum_AR[t]=snowfall_sum_AR[t]+snowfall_incr
          }
          if (T_air[i,j,1]>T_frz+2){
            rainfall_sum_AR[t]=rainfall_sum_AR[t]+precip[i,j,1]
          }
          
          #Move to next AR check
          if (t==summary_data[ar_count,2]) {
            ar_count=ar_count+1
          } 
          
        } #endif AR
        
      }#endif mask
    }}#end nx ny
  
  print(t)
  
}#endt
    
write.matrix(precip_sum_all, file="precip_sum_all.v4.txt")
write.matrix(snowfall_sum_all, file="snowfall_sum_all.v4.txt")
write.matrix(rainfall_sum_all, file="rainfall_sum_all.v4.txt")

write.matrix(precip_sum_AR, file="precip_sum_AR.v4.txt")
write.matrix(snowfall_sum_AR, file="snowfall_sum_AR.v4.txt")
write.matrix(rainfall_sum_AR, file="rainfall_sum_AR.v4.txt")

write.matrix((precip_sum_all-precip_sum_AR), file="precip_sum_nAR.v4.txt")
write.matrix((snowfall_sum_all-snowfall_sum_AR), file="snowfall_sum_nAR.v4.txt")
write.matrix((rainfall_sum_all-rainfall_sum_AR), file="rainfall_sum_nAR.v4.txt")




###############Ran these on CORI, so read in output here instead ########################
#fin=sprintf("precip_sum_all.v2.txt")
#precip_sum_all=read.table(file=fin,sep="")

#fin=sprintf("precip_sum_AR.v2.txt")
#precip_sum_AR=read.table(file=fin,sep="")

#fin=sprintf("snowfall_sum_all.v2.txt")
#snowfall_sum_all=read.table(file=fin,sep="")

#fin=sprintf("snowfall_sum_AR.v2.txt")
#snowfall_sum_AR=read.table(file=fin,sep="")

#fin=sprintf("rainfall_sum_all.v2.txt")
#rainfall_sum_all=read.table(file=fin,sep="")

#fin=sprintf("rainfall_sum_AR.v2.txt")
#rainfall_sum_AR=read.table(file=fin,sep="")

#Now calc cumulative WY totals
cumul_precip_sum_all=array(0,dim=c(8760))
cumul_snowfall_sum_all=array(0,dim=c(8760))
cumul_rainfall_sum_all=array(0,dim=c(8760))

cumul_precip_sum_AR=array(0,dim=c(8760))
cumul_snowfall_sum_AR=array(0,dim=c(8760))
cumul_rainfall_sum_AR=array(0,dim=c(8760))
hour=array(0,dim=c(8760))

for (t in 2:8753) {
  hour[t]=t
  # cumul_precip_sum_all[t]=cumul_precip_sum_all[t-1]+precip_sum_all[t]
  # cumul_snowfall_sum_all[t]=cumul_snowfall_sum_all[t-1]+snowfall_sum_all[t]
  # cumul_rainfall_sum_all[t]=cumul_rainfall_sum_all[t-1]+rainfall_sum_all[t]
  # 
  # cumul_precip_sum_AR[t]=cumul_precip_sum_AR[t-1]+precip_sum_AR[t]
  # cumul_snowfall_sum_AR[t]=cumul_snowfall_sum_AR[t-1]+snowfall_sum_AR[t]
  # cumul_rainfall_sum_AR[t]=cumul_rainfall_sum_AR[t-1]+rainfall_sum_AR[t]
}

write.matrix(cumul_precip_sum_all, file="cumul_precip_sum_all.v4.txt")
write.matrix(cumul_snowfall_sum_all, file="cumul_snowfall_sum_all.v4.txt")
write.matrix(cumul_rainfall_sum_all, file="cumul_rainfall_sum_all.v4.txt")

write.matrix(cumul_precip_sum_AR, file="cumul_precip_sum_AR.v4.txt")
write.matrix(cumul_snowfall_sum_AR, file="cumul_snowfall_sum_AR.v4.txt")
write.matrix(cumul_rainfall_sum_AR, file="cumul_rainfall_sum_AR.v4.txt")




#OMIT THE PLOTTING PART OF THIS SCRIPT HERE


