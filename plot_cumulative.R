source('procdata4.R')
infiles<-c("X2015.04.29datasharing.rda",
           "X2015.04.29Reproducible1.rda",
           "X2015.04.29Exploratory1.rda",
           "X2015.04.29Rprogramming.rda")
infiles=c("X2015.04.29Reproducible1.rda")
enchi=data.frame(coursename=character(),cd=as.Date(character()))
for (ofile in infiles) {
    dd=process4(ofile)
    enchi=rbind(enchi,dd)
    
}
rownames(enchi)=1:nrow(enchi)
save(enchi,file='enchi_2015_04_29')
enchi$dummy=1
ec=aggregate(dummy~cd+coursename,data=enchi,FUN=length)
ec2=reshape(ec,timevar='coursename',idvar='cd',direction='wide')
ec2[is.na(ec2)]=0
ec2=ec2[order(ec2$cd),]
start_date=as.Date("04/07/2014","%m/%d/%Y")

ec2=ec2[ec2$cd>=start_date,]
ec3=cumsum(ec2[,2:5])
ec3$date=ec2$cd

names(ec3)=c('data','reproduce','explore','program','date')
#tdata=reshape(ec3,times='date',idvar=c('data','reproduce','explore','program','date'),direction='long')
library(reshape)
tdata=melt(ec3,id=c('data','reproduce','explore','program'))
tdata=melt(ec3,id='date')
# ec=ddply(enchi,.(coursename,cd),transform)
repolist<-c("jtleek/datasharing",
            "rdpeng/RepData_PeerAssessment1",
            "repos/rdpeng/ExData_Plotting1",
            "rdpeng/ProgrammingAssignment2")


qplot(date,value,data=tdata,color=variable)
ggplot()+geom_point(data=tdata,mapping=aes(x=date,y=value,color=variable))+
    scale_color_discrete(labels=repolist)+
    theme(legend.position=c(0.25,.75),text=element_text(size=20))+
    ylab('Cumulative Forks')
    theme(element_text(size=20))
