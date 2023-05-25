#ERW 1-6-23
#Plot only after running on Cori
#ERW 6-30-21
#Make new bargraph of precip for ARs, incl rain/snow partitioning
#Add timeseries of n-AR precip, incl rain/snow partitioning

library("MASS")
#library(ggplot2)
library(graphics)
#library(fields)
#rm(list=ls())

directory1="/Users/erica/data/cosumnes/hydro_of_ars/results/jan23"
setwd(directory1)


# directory1 = "/global/cscratch1/sd/woodburn/hydro_of_ars/precip_bargraph"
# setwd(directory1)
# source("PFB-ReadFcn.R")
# 
# nx=667
# ny=400
# T_frz=273.66
# 
# #First load 1 pressure head to determine watershed mask
# fin_mask=sprintf("/global/cscratch1/sd/fadji/Parflow01/Parflow/WRF-PF-year/dn7.out.press.00001.pfb") 	
# mask_temp=readpfb(fin_mask,F)
# 
# count_mask=0
# mask=array(0,dim=c(667,400))
# for (j in 1:ny)  {	
#   for (i in 1:nx)  {
#     if (mask_temp[i,j,1]>-3.402823e+38) {
#       mask[i,j]=1
#       count_mask=count_mask+1
#     }
#   }
# }
#count_mask
count_mask=139433
# #139433 or 52.2% cells
# 
# #Read in AR time periods -- only use first two columns of the 17 here
# summary_data=array(0,c(10,17))
# summary_data=read.csv(file="Summary_Table_AR_ERW.txt",header=FALSE,sep="\t")
# 
# precip_sum_all=array(0,dim=c(8760))
# snowfall_sum_all=array(0,dim=c(8760))
# rainfall_sum_all=array(0,dim=c(8760))
# 
# precip_sum_AR=array(0,dim=c(8760))
# snowfall_sum_AR=array(0,dim=c(8760))
# rainfall_sum_AR=array(0,dim=c(8760))
# 
# #Main time loop here
# ar_count=1
# for (t in 1:8753) {
#   
#   fin=sprintf("/global/cscratch1/sd/fadji/Parflow01/Parflow/wrf_forcing_year/WRFd04.APCP.%06d.pfb",t) 	
#   precip=readpfb(fin,F)
#   
#   fin_temp=sprintf("/global/cscratch1/sd/fadji/Parflow01/Parflow/wrf_forcing_year/WRFd04.Temp.%06d.pfb",t)
#   T_air=readpfb(fin_temp,F)
#   
#   for (j in 1:ny)  {	
#     for (i in 1:nx)  {
#       if (mask[i,j]==1) {	
#  
#         #First calc for all time periods
#         
#         precip_sum_all[t]=precip_sum_all[t]+precip[i,j,1]
#         
#         rainfall_incr=0
#         snowfall_incr=0
#         
#         if (T_air[i,j,1]<T_frz){
#           snowfall_sum_all[t]=snowfall_sum_all[t]+precip[i,j,1]
#         }
#         if ((T_air[i,j,1]>=T_frz)&&(T_air[i,j,1]<=(T_frz+2))){
#           rainfall_incr=(-54.632+(0.2*T_air[i,j,1]))*precip[i,j,1]
#           rainfall_sum_all[t]=rainfall_sum_all[t]+rainfall_incr
#           snowfall_incr=precip[i,j,1]-rainfall_incr
#           snowfall_sum_all[t]=snowfall_sum_all[t]+snowfall_incr
#         }
#         if (T_air[i,j,1]>T_frz+2){
#           rainfall_sum_all[t]=rainfall_sum_all[t]+precip[i,j,1]
#         }
#         
#         #Now do for AR
#         if ((t>=summary_data[ar_count,1])&&(t<=summary_data[ar_count,2])&&(ar_count<=10)) {
#           
#           precip_sum_AR[t]=precip_sum_AR[t]+precip[i,j,1]
#       
#           rainfall_incr=0
#           snowfall_incr=0
#           
#           if (T_air[i,j,1]<T_frz){
#             snowfall_sum_AR[t]=snowfall_sum_AR[t]+precip[i,j,1]
#           }
#           if ((T_air[i,j,1]>=T_frz)&&(T_air[i,j,1]<=(T_frz+2))){
#             rainfall_incr=(-54.632+(0.2*T_air[i,j,1]))*precip[i,j,1]
#             rainfall_sum_AR[t]=rainfall_sum_AR[t]+rainfall_incr
#             snowfall_incr=precip[i,j,1]-rainfall_incr
#             snowfall_sum_AR[t]=snowfall_sum_AR[t]+snowfall_incr
#           }
#           if (T_air[i,j,1]>T_frz+2){
#             rainfall_sum_AR[t]=rainfall_sum_AR[t]+precip[i,j,1]
#           }
#           
#           #Move to next AR check
#           if (t==summary_data[ar_count,2]) {
#             ar_count=ar_count+1
#           } 
#           
#         } #endif AR
#         
#       }#endif mask
#     }}#end nx ny
#   
#   print(t)
#   
# }#endt
#     
# write.matrix(precip_sum_all, file="precip_sum_all.v4.txt")
# write.matrix(snowfall_sum_all, file="snowfall_sum_all.v4.txt")
# write.matrix(rainfall_sum_all, file="rainfall_sum_all.v4.txt")
# 
# write.matrix(precip_sum_AR, file="precip_sum_AR.v4.txt")
# write.matrix(snowfall_sum_AR, file="snowfall_sum_AR.v4.txt")
# write.matrix(rainfall_sum_AR, file="rainfall_sum_AR.v4.txt")
# 
# write.matrix((precip_sum_all-precip_sum_AR), file="precip_sum_nAR.v4.txt")
# write.matrix((snowfall_sum_all-snowfall_sum_AR), file="snowfall_sum_nAR.v4.txt")
# write.matrix((rainfall_sum_all-rainfall_sum_AR), file="rainfall_sum_nAR.v4.txt")




###############Ran these on CORI, so read in output here instead ########################
fin=sprintf("precip_sum_all.v4.txt")
precip_sum_all=read.table(file=fin,sep="")

fin=sprintf("precip_sum_AR.v4.txt")
precip_sum_AR=read.table(file=fin,sep="")

fin=sprintf("snowfall_sum_all.v4.txt")
snowfall_sum_all=read.table(file=fin,sep="")

fin=sprintf("snowfall_sum_AR.v4.txt")
snowfall_sum_AR=read.table(file=fin,sep="")

fin=sprintf("rainfall_sum_all.v4.txt")
rainfall_sum_all=read.table(file=fin,sep="")

fin=sprintf("rainfall_sum_AR.v4.txt")
rainfall_sum_AR=read.table(file=fin,sep="")

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
  cumul_precip_sum_all[t]=cumul_precip_sum_all[t-1]+precip_sum_all[t,1]
  cumul_snowfall_sum_all[t]=cumul_snowfall_sum_all[t-1]+snowfall_sum_all[t,1]
  cumul_rainfall_sum_all[t]=cumul_rainfall_sum_all[t-1]+rainfall_sum_all[t,1]

  cumul_precip_sum_AR[t]=cumul_precip_sum_AR[t-1]+precip_sum_AR[t,1]
  cumul_snowfall_sum_AR[t]=cumul_snowfall_sum_AR[t-1]+snowfall_sum_AR[t,1]
  cumul_rainfall_sum_AR[t]=cumul_rainfall_sum_AR[t-1]+rainfall_sum_AR[t,1]
}

write.matrix(cumul_precip_sum_all, file="cumul_precip_sum_all.v5.txt")
write.matrix(cumul_snowfall_sum_all, file="cumul_snowfall_sum_all.v5.txt")
write.matrix(cumul_rainfall_sum_all, file="cumul_rainfall_sum_all.v5.txt")

write.matrix(cumul_precip_sum_AR, file="cumul_precip_sum_AR.v5.txt")
write.matrix(cumul_snowfall_sum_AR, file="cumul_snowfall_sum_AR.v5.txt")
write.matrix(cumul_rainfall_sum_AR, file="cumul_rainfall_sum_AR.v5.txt")





###############Ran these on CORI, so read in output here instead ########################
# fin=sprintf("precip_sum_all.v4.txt")
# precip_sum_all=read.table(file=fin,sep="")
# 
# fin=sprintf("precip_sum_AR.v4.txt")
# precip_sum_AR=read.table(file=fin,sep="")
# 
# fin=sprintf("snowfall_sum_all.v4.txt")
# snowfall_sum_all=read.table(file=fin,sep="")
# 
# fin=sprintf("snowfall_sum_AR.v4.txt")
# snowfall_sum_AR=read.table(file=fin,sep="")
# 
# fin=sprintf("rainfall_sum_all.v4.txt")
# rainfall_sum_all=read.table(file=fin,sep="")
# 
# fin=sprintf("rainfall_sum_AR.v4.txt")
# rainfall_sum_AR=read.table(file=fin,sep="")
# 
# 
# 
# fin=sprintf("cumul_precip_sum_all.v4.txt")
# cumul_precip_sum_all=read.table(file=fin,sep="")
# 
# fin=sprintf("cumul_precip_sum_AR.v4.txt")
# cumul_precip_sum_AR=read.table(file=fin,sep="")
# 
# fin=sprintf("cumul_snowfall_sum_all.v4.txt")
# cumul_snowfall_sum_all=read.table(file=fin,sep="")
# 
# fin=sprintf("cumul_snowfall_sum_AR.v4.txt")
# cumul_snowfall_sum_AR=read.table(file=fin,sep="")
# 
# fin=sprintf("cumul_rainfall_sum_all.v4.txt")
# cumul_rainfall_sum_all=read.table(file=fin,sep="")
# 
# fin=sprintf("cumul_rainfall_sum_AR.v4.txt")
# cumul_rainfall_sum_AR=read.table(file=fin,sep="")

#End of year totals - update commented values

cumul_precip_sum_all[8753] #79180.07
cumul_rainfall_sum_all[8753] #66656.68
cumul_snowfall_sum_all[8753] #12523.4
#nAR fraction of precip that is snowfall =
cumul_snowfall_sum_all[8753] / cumul_precip_sum_all[8753]*100 #15.81635

cumul_precip_sum_AR[8753] #41622.96
cumul_rainfall_sum_AR[8753] #36126.06
cumul_snowfall_sum_AR[8753] #5496.903
#AR fraction of precip that is snowfall =
cumul_snowfall_sum_AR[8753] / cumul_precip_sum_AR[8753]*100 #13.20642%

#Fraction of total precip that is AR
cumul_precip_sum_AR[8753]/cumul_precip_sum_all[8753]*100 #52.56747%



Fig_out='Fig.precip_AR_v_nAR.v4.pdf'
pdf(file=Fig_out)
par(mfrow=c(1,2))
plot(x=hour[1:8753]/24,y=cumul_precip_sum_AR[1:8753]*3600/count_mask,type="l",ylim=c(0,1100),ylab="AR average precipitation total (mm)",xlab="Day of WY")
lines(x=hour[1:8753]/24,y=cumul_rainfall_sum_AR[1:8753]*3600/count_mask,col="blue")
lines(x=hour[1:8753]/24,y=cumul_snowfall_sum_AR[1:8753]*3600/count_mask,col="cyan")

plot(x=hour[1:8753]/24,y=(cumul_precip_sum_all[1:8753]-cumul_precip_sum_AR[1:8753])*3600/count_mask,type="l",ylim=c(0,1100),ylab="nAR average precipitation total (mm)",xlab="Day of WY")
lines(x=hour[1:8753]/24,y=(cumul_rainfall_sum_all[1:8753]-cumul_rainfall_sum_AR[1:8753])*3600/count_mask,col="blue")
lines(x=hour[1:8753]/24,y=(cumul_snowfall_sum_all[1:8753]-cumul_snowfall_sum_AR[1:8753])*3600/count_mask,col="cyan")
dev.off()


Fig_out='Fig.precip_all.v4.pdf'
pdf(file=Fig_out)
par(mfrow=c(1,))
plot(x=hour[1:8753]/24,y=(cumul_precip_sum_all[1:8753]*3600/count_mask),type="l",ylab="Average precipitation total (mm)",xlab="Day of WY")
lines(x=hour[1:8753]/24,y=(cumul_rainfall_sum_all[1:8753]*3600/count_mask),col="blue")
lines(x=hour[1:8753]/24,y=(cumul_snowfall_sum_all[1:8753]*3600/count_mask),col="cyan")
dev.off()

Fig_out='Fig.precip_AR_v_nAR.stacked.v4.png'
png(file=Fig_out)
par(mfrow=c(1,1))
#Change so margin doesn't get cut off
par(mar=c(5,6,4,1)+.1)
plot(x=hour[1:8753]/24,y=(cumul_precip_sum_all[1:8753]*3600/count_mask),ylim=c(0,2000),type="l",ylab="Average Cumulative Precipitation (mm)",xlab="Day of WY",cex.lab = 2,cex.axis = 2, box=FALSE)
rect(305/24,0,393/24,3500,col="bisque2",border='NA')
rect(1671/24,0,1811/24,3500,col="bisque2",border='NA')
rect(2276/24,0,2318/24,3500,col="bisque2",border='NA')
rect(2365/24,0,2415/24,3500,col="bisque2",border='NA')
rect(2433/24,0,2459/24,3500,col="bisque2",border='NA')
rect(2617/24,0,2649/24,3500,col="bisque2",border='NA')
rect(3074/24,0,3200/24,3500,col="bisque2",border='NA')
rect(3294/24,0,3336/24,3500,col="bisque2",border='NA')
rect(3401/24,0,3446/24,3500,col="bisque2",border='NA')
rect(4475/24,0,4549/24,3500,col="bisque2",border='NA')
polygon(x=c(1,hour[1:8753]/24,8753/24),y=c(0,((cumul_precip_sum_all[1:8753])*3600/count_mask),0),col="deepskyblue2")
#polygon(x=c(1,hour[1:8753]/24,8753/24),y=c(0,((cumul_precip_sum_AR[1:8753]-(cumul_rainfall_sum_all[1:8753,1]-cumul_rainfall_sum_AR[1:8753,1]))*3600/count_mask),0),col="deepskyblue2")
polygon(x=c(1,hour[1:8753]/24,8753/24),y=c(0,((cumul_snowfall_sum_all[1:8753]+cumul_rainfall_sum_AR[1:8753,1])*3600/count_mask),0),col="white",density=25)
polygon(x=c(1,hour[1:8753]/24,8753/24),y=c(0,(cumul_snowfall_sum_all[1:8753]*3600/count_mask),0),col="white")
polygon(x=c(1,hour[1:8753]/24,8753/24),y=c(0,(cumul_snowfall_sum_AR[1:8753]*3600/count_mask),0),col="antiquewhite4",density=25)
lines(x=hour[1:8753]/24,y=(cumul_snowfall_sum_all[1:8753]+cumul_rainfall_sum_AR[1:8753])*3600/count_mask)
lines(x=hour[1:8753]/24,y=(cumul_snowfall_sum_all[1:8753]*3600/count_mask))
lines(x=hour[1:8753]/24,y=(cumul_snowfall_sum_AR[1:8753]*3600/count_mask))
text(260,1600,"non-AR rain",cex= 2)
text(260,700,"AR rain",cex= 2)
text(260,240,"non-AR snow",cex= 2)
text(260,60,"AR snow",cex= 2)
dev.off()




Fig_out='Fig.precip_AR_v_nAR.stacked.v44.png'
png(file=Fig_out)
par(mfrow=c(1,1))
plot(x=hour[1:8753]/24,y=(cumul_precip_sum_all[1:8753]*3600/count_mask),ylim=c(0,2000),type="l",ylab="Average Cumulative Precipitation (mm)",xlab="Day of WY")
rect(305/24,0,393/24,3500,col="bisque2",border='NA')
rect(1671/24,0,1811/24,3500,col="bisque2",border='NA')
rect(2276/24,0,2318/24,3500,col="bisque2",border='NA')
rect(2365/24,0,2415/24,3500,col="bisque2",border='NA')
rect(2433/24,0,2459/24,3500,col="bisque2",border='NA')
rect(2617/24,0,2649/24,3500,col="bisque2",border='NA')
rect(3074/24,0,3200/24,3500,col="bisque2",border='NA')
rect(3294/24,0,3336/24,3500,col="bisque2",border='NA')
rect(3401/24,0,3446/24,3500,col="bisque2",border='NA')
rect(4475/24,0,4549/24,3500,col="bisque2",border='NA')
polygon(x=c(1,hour[1:8753]/24,8753/24),y=c(0,((cumul_precip_sum_all[1:8753])*3600/count_mask),0),col="white")
#polygon(x=c(1,hour[1:8753]/24,8753/24),y=c(0,((cumul_precip_sum_AR[1:8753]-(cumul_rainfall_sum_all[1:8753]-cumul_rainfall_sum_AR[1:8753]))*3600/count_mask),0),col="deepskyblue2")
polygon(x=c(1,hour[1:8753]/24,8753/24),y=c(0,((cumul_snowfall_sum_all[1:8753]+cumul_rainfall_sum_AR[1:8753])*3600/count_mask),0),col="white",density=25)
polygon(x=c(1,hour[1:8753]/24,8753/24),y=c(0,(cumul_snowfall_sum_all[1:8753]*3600/count_mask),0),col="white")

polygon(x=c(1,hour[1:8753]/24,8753/24),y=c(0,((cumul_rainfall_sum_AR[1:8753]+cumul_snowfall_sum_AR[1:8753])*3600/count_mask),0),col="antiquewhite4",density=25)
polygon(x=c(1,hour[1:8753]/24,8753/24),y=c(0,(cumul_snowfall_sum_AR[1:8753]*3600/count_mask),0),col="antiquewhite4",density=25)
lines(x=hour[1:8753]/24,y=(cumul_snowfall_sum_all[1:8753]+cumul_rainfall_sum_AR[1:8753])*3600/count_mask)
lines(x=hour[1:8753]/24,y=(cumul_snowfall_sum_all[1:8753]*3600/count_mask))
lines(x=hour[1:8753]/24,y=(cumul_snowfall_sum_AR[1:8753]*3600/count_mask))
text(260,1600,"non-AR rain")
text(260,700,"AR rain")
text(260,240,"non-AR snow")
text(260,60,"AR snow")
dev.off()


#This one wont' work to plot if just reading files from Cori
# Fig_out='Fig.barplot_new.v4.png'
# png(file=Fig_out)
# par(mfrow=c(1,1)) 
# array_AR=array(0,dim=c(3,10))
# array_AR[1,1:10]=precip_sum_AR[1:10,1]
# array_AR[2,1:10]=rainfall_sum_AR[1:10,1]
# array_AR[3,1:10]=snowfall_sum_AR[1:10,1]
# barplot(array_AR[2:3,1:10]*3600/count_mask,beside=FALSE,col=c("deepskyblue2","gray"),ylim=c(-15,250),ylab="Average Precipitation total (mm)",density=30)
# text(.7,-10,"AR1")
# text(1.9,-10,"AR2")
# text(3.1,-10,"AR3")
# text(4.3,-10,"AR4")
# text(5.5,-10,"AR5")
# text(6.7,-10,"AR6")
# text(7.9,-10,"AR7")
# text(9.1,-10,"AR8")
# text(10.3,-10,"AR9")
# text(11.5,-10,"AR10")
# text(11.,240,"Rain",col="deepskyblue",cex=1.3)
# text(11.,225,"Snow",col="gray",cex=1.3)
# dev.off()
# 
# 
# 
