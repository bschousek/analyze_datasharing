library(lubridate)
library(ggplot2)
#load("compiled.rda")

interesting<-data.frame(id=jforks$id)
interesting$html_url<-jforks$html_url

interesting$created_at<-strptime(jforks$created_at,format="%Y-%m-%dT%H:%M:%S",tz="GMT")
interesting$updated_at<-strptime(jforks$updated_at,format="%Y-%m-%dT%H:%M:%S",tz="GMT")
interesting$pushed_at<-strptime(jforks$pushed_at,format="%Y-%m-%dT%H:%M:%S",tz="GMT")
interesting$size<-jforks$size

interesting$running<-length(interesting$id):1
interesting$created.day<-mday(interesting$created_at)
interesting$created.month<-month(interesting$created_at)
interesting$created.year<-year(interesting$created_at)
interesting$updated.day<-mday(interesting$updated_at)
interesting$updated.month<-month(interesting$updated_at)
interesting$updated.year<-year(interesting$updated_at)
save(interesting,file="somewhat_tidy.rda")
classdates<-interesting$created.month %in% c(4,5,6)
class.starts<-factor(x=1:12,labels=c(7,5,2),levels=c(4,5,6))

more.interesting<-interesting[which(classdates),]
vector.starts<-class.starts[more.interesting$created.month]
v2.starts<-as.numeric(levels(vector.starts)[vector.starts])
nulled.create<-more.interesting$created.day-v2.starts
nulled.update<-more.interesting$updated.day-v2.starts
more.interesting$create.nulled<-nulled.create
more.interesting$update.nulled<-nulled.update
hist_cut <- ggplot(more.interesting, aes(x=create.nulled, fill=as.factor(created.month)))+
			geom_bar(position="dodge")+
			labs(title="Forks of datasharing repository",y="Forks created per day",x="days since course start")

print(hist_cut)
hist_cut2 <- ggplot(more.interesting, aes(x=update.nulled, fill=as.factor(created.month)))+geom_bar(position="dodge")
print(hist_cut2)

more.interesting$dummy<-rep(1,length(more.interesting$id))
separate<-with(more.interesting,aggregate(dummy,by=list(created.day,created.month),sum))