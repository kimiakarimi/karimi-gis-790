#packages: 
#install.packages(c("dataRetrieval","EGRET"))
library(EGRET)
library(dataRetrieval)

#basic parameters
paLong <- 12 #number of months per year you want analyzed
paStart <- 1 #number of month to start analysis in 
QParameterCd<-"00060"  ###Daily mean flow.


StartDate = "1981-10-01"
EndDate = "2018-03-01"
#UserPath = "" #define the path of a user file for readUserSample() !!!!!slashes are reversed in R
#USerFile = "" #define the name of a user file for readUserSample()
USGSSite = "02096960" #number of USGS site flow data is from

####### Get flow data 
Daily <-readNWISDaily("02096960",QParameterCd,StartDate, EndDate)

?readNWISDaily
###### Get nutrients concentrations
#this is the automatic data retrieval method for USGS sites, 
#however USGS sites don't usually have the most data
#"00625": USGS data code for which data to be used as the actual sample data
Sample <- readNWISSample("02096960", "00625", StartDate, EndDate)  

#this function reads sample data from a user created & defined file, which is necessary for pretty much all sample data
#Sample <- readUserSample(filePath = UserPath, fileName = UserFile, hasHeader = TRUE, separator = ",")

####### 
INFO <- readNWISInfo(USGSSite,"",interactive = FALSE)

###### Run WRTDS
eList <- mergeReport (INFO,Daily,Sample)
eList <- setPA(eList, paStart, paLong)
eList <- modelEstimation(eList, minNumObs = 85) #minNumObs must be greater than the number of data points in Sample
#if there are gaps of sample data which would cause poor estimates during periods of a year or more this function removes them from output
eList <- blankTime(eList, "1992-01-01", "1988-01-01") 

###To get daily values 
dailyvalues=eList[[2]]

exp(.367)
#Outputs
#there are many possible outputs, I recommend looking through the manual to determine what is useful in any given case.
####Concentrations and Model outputs
plotConcTimeDaily(eList)

#######These are of the RAW DATA, not WRTDS outputs
#####################################################

#####Just concentration vs. time between given flows on log scale

flowDuration(eList, qUnit = 1) #To get summary of flows at site.

plotConcTime(eList,logScale=TRUE, qUnit=1,qUpper=4000,qLower=1000) 

####Just concentration vs. flows
plotConcQ(eList,logScale=TRUE)

####Flux (thousands of kg/day vs. discharge)
plotFluxQ(eList, fluxUnit=4)


####Boxplots by month
boxConcMonth(eList)

boxQTwice(eList)

#####This gives you the best of all of the above
###################################################
multiPlotDataOverview (eList)

#############################################################
###############WRTDS output 
#########################################################
t=eList[[2]]  ##This gives you the daily values of WRTDS predictions
              ### IT has concentrations and fluxes, also flow normalized ones

plotConcTimeDaily(eList)




####COntour plot 
plotContours(eList, yearStart=2004,yearEnd=2006,qBottom=100,qTop=5000,contourLevels=seq(0,2,.2)) 


plotContours(eList)

