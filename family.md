

```r
    for (infile in infiles) {
    infile
    load(infile)
    source("create_classtable.R")
    source("procdata2.R")
    #str(c)
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
}
```
