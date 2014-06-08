checkrepo <- function(next_url) {
    
    keep_going<-TRUE
    jforks<-data.frame()
    while(keep_going==TRUE) {
        req <- GET(nexturl, config(token = github_token))
        stop_for_status(req)
        
        reg.geturl<-"<(.*)>"
        nexturls<-req$headers$link
        nexturl<-strsplit(nexturls,",")
        #If "last" is not in the returned urls list, then this is the last one
        findlast<-lapply(nexturl,function(ch) grep("last",ch))
        stillmore=findlast>0
        keep_going=!is.na(stillmore)
        
        linkm<-regexpr(reg.geturl,unlist(nexturl[1]),perl=T)
        link<-regmatches(unlist(nexturl[1]),linkm)
        nexturl<-substr(link[1],2,nchar(link[1])-1)
        #keep_going<-keep_going+1
        forks<-content(req,as="text")
        newforks<-fromJSON(forks)#hack
        newforks$owner<-NULL
        newforks$permissions<-NULL
        jforks<-rbind(jforks,newforks)
        
        print(link[1])
        
        #if (link[4]==link[2]) {keep_going=FALSE}
        
    }
    jforks
}