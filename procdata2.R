require(lubridate)
require(ggplot2)
require(dplyr)
#load("compiled.rda")

interesting<-data.frame(id=jforks$id)
interesting$coursename<-jforks$name

interesting$created_at<-strptime(jforks$created_at,format="%Y-%m-%dT%H:%M:%S",tz="GMT")
interesting$updated_at<-strptime(jforks$updated_at,format="%Y-%m-%dT%H:%M:%S",tz="GMT")
interesting$pushed_at<-strptime(jforks$pushed_at,format="%Y-%m-%dT%H:%M:%S",tz="GMT")
interesting$size<-jforks$size
interesting$html_url<-jforks$html_url

interesting$created.day<-mday(interesting$created_at)
interesting$created.month<-as.factor(month(interesting$created_at))
interesting$created.year<-as.factor(year(interesting$created_at))
interesting$updated.day<-mday(interesting$updated_at)
interesting$updated.month<-month(interesting$updated_at)
interesting$updated.year<-year(interesting$updated_at)

interesting<-merge(interesting,classtable,by=c("coursename","created.month","created.year"))

interesting$created.null<-interesting$created.day-interesting$start

a<-interesting %.%
    select(created.month,created.null,created.year) %.%
    group_by(created.month,created.year,created.null)%.%
    arrange(created.month,created.null)%.%
    mutate(dummy=1)%.%
    summarize(total=sum(dummy))%.%
    group_by(created.month,created.year)%.%
    mutate(running=cumsum(total))


b<-a%.%
    select(created.null,total)%.%
    group_by(created.null)%.%
    summarize(total=sum(total))%.%
    mutate(running=cumsum(total))
b$created.month<-as.factor(rep("total",length(b$total)))
b$created.year<-b$created.month
c<-rbind(a,b)
title<-paste("Forked repos for",interesting$coursename[1])
ggplot(c,aes(x=created.null,y=running))+
    geom_line(aes(group=created.month,col=created.month))+
    ggtitle(title)+
    xlab("time since start of class (days)")+
    ylab("running total of repos forked")
    


ggplot(c,aes(x=created.null,y=total))+
    geom_line(aes(group=created.month,col=created.month))+
    ggtitle(title)+
    xlab("time since start of class (days)")+
    ylab("repos forked per day")

#ggplot(b,aes(x=created.null,y=total))+geom_line()
#ggplot(a,aes(x=created.null,y=running))+
#    geom_line(aes(group=created.month,col=created.month))+
#    geom_line(b,aes(x=created.null,y=running))

