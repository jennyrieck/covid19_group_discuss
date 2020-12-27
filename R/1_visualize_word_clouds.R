library(wordcloud)
library(RColorBrewer)
############ Word clouds
### Words

full.word.cloud.mat<-data.frame(word = colnames(Y),freq=colSums(Y))
set.seed(1234) # for reproducibility 
layout(matrix(c(1, 2), nrow=2), heights=c(.25, 4))
par(mar=rep(0, 4))
plot.new()
text(x=0.5, y=0.5, gsub('\\.', ' ', grpdisc.Q),cex = 1.5)
wordcloud(words = full.word.cloud.mat$word, freq = full.word.cloud.mat$freq, min.freq = 4,           
          max.words=300, random.order=FALSE, rot.per=0, scale=c(3.5,0.25),           
          colors=brewer.pal(8, "Dark2"))

### Demographics
demogs.labels.long<- c("Indigenous","Black","Racialized","Youth","Women","Seniors","LGBTQ2S","Newcomers.Refugees",
                       "Disabilities", "Low.income", "Homelessness", "Underhoused", "Consumer.survivors", 
                       "Addiction","Gender.violence","Incarcerated", "Cultural.Religious")



full.demog.cloud.mat<-data.frame(word = demogs.labels.long,freq=colSums(X))
set.seed(1234) # for reproducibility 
layout(matrix(c(1, 2), nrow=2), heights=c(.25, 4))
par(mar=rep(0, 4))
plot.new()
text(x=0.5, y=.5, 'Vulnerable Populations Demographics',cex = 1.5)
wordcloud(words = full.demog.cloud.mat$word, freq = full.word.cloud.mat$freq, min.freq = 1,           
          max.words=500, random.order=FALSE, rot.per=0, scale=c(4.5,1),
          colors=brewer.pal(8, "Dark2"))
