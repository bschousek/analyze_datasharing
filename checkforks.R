library(httr)
library(jsonlite)

#tokens.R contains a private key. The file looks like:
#  Client.ID<-"<number>"
#  Client.Secret<-"<number>"
#I keep that unsynced with github so you need to get your own
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
repolist<-c("https://api.github.com/repos/jtleek/datasharing/forks",
            "https://api.github.com/repos/rdpeng/RepData_PeerAssessment1/forks",
            "https://api.github.com/repos/rdpeng/ExData_Plotting1/forks",
            "https://api.github.com/repos/rdpeng/ProgrammingAssignment2/forks")
outlist<-c("datasharing",
           "Reproducible1",
           "Exploratory1",
           "Rprogramming")
           #repolist<-c("https://api.github.com/repos/rdpeng/RepData_PeerAssessment1/forks",
#            "https://api.github.com/repos/rdpeng/ExData_Plotting1/forks",
#            "https://api.github.com/repos/rdpeng/ProgrammingAssignment2/forks")

nexturl<-"https://api.github.com/repos/jtleek/datasharing/forks?per_page=100"

source("fn.checkrepo.r")
biglist<-data.frame()
for (nexturl in repolist) {
    jforks<-checkrepo(nexturl)
    jforks$reponame<-rep(nexturl,length(jforks$id))
    
    fname<-paste(make.names(Sys.time()),outlist[which(repolist==nexturl)],".rda",sep="")
    
    save(jforks,file=fname)
}
#save(jforks,file="compiled.rda")
