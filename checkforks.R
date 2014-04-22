library(httr)
library(jsonlite)
source('tokens.R')
# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. Register an application at https://github.com/settings/applications
#    Insert your values below - if secret is omitted, it will look it up in
#    the GITHUB_CONSUMER_SECRET environmental variable.
#
#    Use http://localhost:1410 as the callback url
myapp <- oauth_app("github", Client.ID,Client.Secret)

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
req2 <- GET("https://api.github.com/rate_limit", config(token = github_token))
stop_for_status(req2)
content(req2)
nexturl<-"https://api.github.com/repos/jtleek/datasharing/forks"
keep_going<-TRUE
jforks<-data.frame()
while(keep_going) {
    req <- GET(nexturl, config(token = github_token))
    stop_for_status(req)

    reg.geturl<-"<(.*)>"
    nexturls<-req$headers$link
    nexturl<-strsplit(nexturls,",")
    linkm<-regexpr(reg.geturl,unlist(nexturl[1]),perl=T)
    link<-regmatches(unlist(nexturl[1]),linkm)
    nexturl<-substr(link[1],2,nchar(link[1])-1)
    keep_going<-keep_going+1
    forks<-content(req,as="text")
    newforks<-fromJSON(forks)#hack
    newforks$owner<-NULL
    newforks$permissions<-NULL
    jforks<-rbind(jforks,newforks)

    print(link[1])
    if (link[4]==link[2]) {keep_going=FALSE}

}

