#### LOAD PACKAGES
#library(devtools)
### textnets by Christopher Bail for prepping text input and coutning lemma frequency
#devtools::install_github("cbail/textnets")
library(textnets)
library(tidytext)
library(reshape2)

## Download the latest version of the group discussion results from opendatatoronto

download.file("https://ckan0.cf.opendata.inter.prod-toronto.ca/download_resource/55829124-3d8d-4dfa-9102-40911837e6d7", 
              "../data/spt-group-discussion-results.csv")

data.in<-read.csv('../data/spt-group-discussion-results.csv', na.strings = c('N/A', '', 'n/a','na'), stringsAsFactors = F)


######################################################
### Formant Vulnerable Population Demographic Characteristics
######################################################

demog.vars.cols<-c(4:20)
demogs.counts.out<-data.in[,demog.vars.cols]
demogs.counts.out[is.na(demogs.counts.out)]<-0

## Shorten demographic group labels 
demogs.labels<-names(demogs.counts.out)
demogs.labels<-gsub('Persons.*ing.','',demogs.labels)
demogs.labels<-gsub('People.with.','',demogs.labels)
demogs.labels<-gsub('P.*face.','',demogs.labels)
demogs.labels<-gsub('.based','',demogs.labels)
demogs.labels<-substr(demogs.labels,1,10)

## Create focus group by demographic counts matrix
colnames(demogs.counts.out)<-toupper(demogs.labels)
rownames(demogs.counts.out)<-data.in$Respondent.ID


######################################################
### Formant word usage in group discussion narratives
######################################################

## Specify which question to analyze
grpdisc.Q <-'Ways.in.which.you.were.personally.impacted'
#grpdisc.Q <-'Supports..programs.and.services.you.were.accessing.before.COVID.19'
#grpdisc.Q <- 'Urgent.supports.needed'

## Count lemmas in narrative text, removing common stop words (e.g., "the", "is", "that")
grpdisc.word.counts.all<- PrepText(textdata = data.in,groupvar =  'Respondent.ID', textvar = grpdisc.Q,
                                   node_type="words", tokenizer = "words", pos = "all", remove_stop_words = TRUE, compound_nouns = TRUE)

## Keep all the lemmas that occur at least twice number of times in the narrative text
words.to.keep<-with(grpdisc.word.counts.all, table(lemma))>1
words.to.keep<-names(words.to.keep)[words.to.keep==T]

## Remove short words (i.e., less than 2 characters long)
words.to.keep<- words.to.keep[(nchar(words.to.keep) >= 3)] 

## Remove words that don't begin with a letter (i.e., numbers)
words.to.keep<-grep('^[[:alpha:]]',words.to.keep,value = T)

## Other stopwords lists to remove (stopwords-iso from stopwords package)
other.words.to.remove<-get_stopwords('en', 'stopwords-iso')$word
  
  #c("none", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten",
  #                       "either", "whether", "thing", "something", "also", "moreover", "since")
words.to.keep<-words.to.keep[!words.to.keep %in% other.words.to.remove]

### reformat data with only the lemma we want
grpdisc.word.counts.all$keep<-F
for(w in words.to.keep){
  grpdisc.word.counts.all$keep[grep(paste0('^',w,'$'),grpdisc.word.counts.all$lemma,value = F)]  <-T
  
}

grpdisc.word.counts.cut<-grpdisc.word.counts.all[grpdisc.word.counts.all$keep==T,]

### Reshape the words counts so it's focus group ids by word counts

grpdisc.word.counts.by.id<-dcast(grpdisc.word.counts.cut, Respondent.ID~lemma,value.var = "count")
grpdisc.word.counts.by.id[is.na(grpdisc.word.counts.by.id)]<-0

##grpdisc.word.counts.by.id<-as.data.frame.matrix(table(grpdisc.word.counts.cut$Respondent.ID, grpdisc.word.counts.cut$lemma))


###############################################
###### Final format and save both count matrices

### Some focus groups did not provide answers for all questions, 
### so we must find the groups common between our demographics an dour word counts

X.demogs<-as.matrix(demogs.counts.out[match( rownames(grpdisc.word.counts.by.id),rownames(demogs.counts.out)),])
Y.words<-as.matrix(grpdisc.word.counts.by.id)

save(grpdisc.Q, X.demogs, Y.words, file=paste0('../data/word_counts_', substr(grpdisc.Q,1,42), '.rda'))

