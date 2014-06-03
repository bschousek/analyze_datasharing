library(lubridate)
#load("compiled.rda")
interesting<-data.frame(id=jforks$id)
interesting$html_url<-jforks$html_url

interesting$created_at<-strptime(jforks$created_at,format="%Y-%m-%dT%H:%M:%S",tz="GMT")
interesting$updated_at<-strptime(jforks$updated_at,format="%Y-%m-%dT%H:%M:%S",tz="GMT")
interesting$pushed_at<-strptime(jforks$pushed_at,format="%Y-%m-%dT%H:%M:%S",tz="GMT")
interesting$size<-jforks$size
save(interesting,file="somewhat_tidy.rda")

interesting$running<-length(interesting$id):1
interesting$created.day<-mday(interesting$created_at)
interesting$createmonth<-month(interesting$created_at)

hist_cut <- ggplot(interesting, aes(x=created.day, fill=as.factor(createmonth)))+geom_bar()
print(hist_cut)