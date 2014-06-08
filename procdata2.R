library(lubridate)
library(ggplot2)
library(dplyr)
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

ggplot(a,aes(x=created.null,y=running))+geom_line(aes(group=created.month,col=created.month))
ggplot(a,aes(x=created.null,y=total))+geom_line(aes(group=created.month,col=created.month))

#b<-a%.%group_by(created.month)%.%mutate(running=cumsum(total))
