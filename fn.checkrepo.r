checkrepo <- function(next_url) {
    pages="&per_page=100"
    # pages=""
    keep_going<-TRUE
    jforks<-data.frame()
    index=0
    while(keep_going==TRUE) {
        
        req <- GET(nexturl, config(token = github_token))
        # print(headers(req))
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
        # print(nexturl)
        nexturl=paste(nexturl,pages,sep='')
        # print(nexturl)
        #keep_going<-keep_going+1
        forks<-content(req,as="text")
        newforks<-fromJSON(forks)#hack
        newforks$owner<-NULL
        newforks$permissions<-NULL
        jforks<-rbind(jforks,newforks)
        
        print(link[1])
        index=index+1
        # if (index==5) {keep_going=FALSE}
        #if (link[4]==link[2]) {keep_going=FALSE}
        
    }
    jforks
}