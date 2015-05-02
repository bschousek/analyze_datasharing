require(lubridate)
require(ggplot2)
require(dplyr)
#load("compiled.rda")
process4<-function(infile) {
    source("create_classtable.R")
    load(infile)
    interesting<-data.frame(id=jforks$id)
    interesting$coursename<-as.factor(infile)
    interesting$reponame<-jforks$name
    
    interesting$created_at<-strptime(jforks$created_at,format="%Y-%m-%dT%H:%M:%S",tz="GMT")
    interesting$updated_at<-strptime(jforks$updated_at,format="%Y-%m-%dT%H:%M:%S",tz="GMT")
    interesting$pushed_at<-strptime(jforks$pushed_at,format="%Y-%m-%dT%H:%M:%S",tz="GMT")
    interesting$cd=as.Date(interesting$created_at)
    interesting$ud=as.Date(interesting$updated_at)
    interesting$pa=as.Date(interesting$pushed_at)
    interesting$size<-jforks$size
    interesting$html_url<-jforks$html_url
    
    interesting$created.day<-mday(interesting$created_at)
    interesting
}
