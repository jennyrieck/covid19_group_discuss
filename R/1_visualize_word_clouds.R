library(wordcloud)
library(RColorBrewer)

###### Create word clouds showing frequency of demographic characteristics 
###### and words  used in response to questions


grpdisc.Q <-'Ways.in.which.you.were.personally.impacted'
#grpdisc.Q <-'Supports..programs.and.services.you.were.accessing.before.COVID.19'
#grpdisc.Q <- 'Urgent.supports.needed'


load(paste0('../data/word_counts_', substr(grpdisc.Q,1,42), '.rda'))

###############################
### Vulnerable Populations Demographic characteristics
###############################

demogs.labels.long<- c("Indigenous","Black","Racialized","Youth","Women","Seniors","LGBTQ2S","Newcomers.Refugees",
                       "Disabilities", "Low.income", "Homelessness", "Underhoused", "Consumer.survivors", 
                       "Addiction","Gender.violence","Incarcerated", "Cultural.Religious")

full.demog.cloud.mat<-data.frame(word = demogs.labels.long,freq=colSums(X.demogs))
set.seed(1234) # for reproducibility 
png(file=paste0("../plots/wordcloud_demogs_",substr(grpdisc.Q,1,42),".png"),height=400,width=400)
layout(matrix(c(1, 2), nrow=2), heights=c(.25, 4))
par(mar=rep(0, 4))
plot.new()
text(x=0.5, y=.5, 'Vulnerable Populations Demographics',cex = 1.5)
wordcloud(words = full.demog.cloud.mat$word, freq = full.word.cloud.mat$freq, min.freq = 1,           
          max.words=500, random.order=FALSE, rot.per=0, scale=c(4.5,1),
          colors=brewer.pal(8, "Dark2"))
dev.off()

###############################
### Word frequency cloud
###############################

full.word.cloud.mat<-data.frame(word = colnames(Y.words),freq=colSums(Y.words))
set.seed(1234) # for reproducibility 

png(file=paste0("../plots/wordcloud_words_",substr(grpdisc.Q,1,42),".png"),height=400,width=400)
layout(matrix(c(1, 2), nrow=2), heights=c(.25, 4))
par(mar=rep(0, 4))
plot.new()
text(x=0.5, y=0.5, gsub('\\.', ' ', grpdisc.Q),cex = 1.5)
wordcloud(words = full.word.cloud.mat$word, freq = full.word.cloud.mat$freq, min.freq = 4,           
          max.words=300, random.order=FALSE, rot.per=0, scale=c(3.5,0.25),           
          colors=brewer.pal(8, "Dark2"))
dev.off()