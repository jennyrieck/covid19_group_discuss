#### LOAD PACKAGES
#library(devtools)
### textnets by Christopher Bail for prepping text input and coutning lemma frequency
#install_github("cbail/textnets", force=TRUE)
library(textnets)

## Download the latest version of the group discussion results from opendatatoronto
download.file("https://ckan0.cf.opendata.inter.prod-toronto.ca/download_resource/55829124-3d8d-4dfa-9102-40911837e6d7", 
              "../data/spt-group-discussion-results.csv")

data.in<-read.csv('spt-group-discussion-results.csv', na.strings = c('N/A', '', 'n/a','na'), stringsAsFactors = F)

## Specify which question to analyze
grpdisc.Q <-'Ways.in.which.you.were.personally.impacted'

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

## Other common words to remove that are not as descriptive
other.words.to.remove<-c("none", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten",
                         "either", "whether", "thing", "something", "also", "moreover", "since")

words.to.keep<-words.to.keep[!words.to.keep %in% other.words.to.remove]

### reformat data with only the lemma we want
grpdisc.word.counts.all$keep<-F
for(w in words.to.keep){
  grpdisc.word.counts.all$keep[grep(paste0('^',w,'$'),grpdisc.word.counts.all$lemma,value = F)]  <-T
  
}

grpdisc.word.counts.cut<-grpdisc.word.counts.all[grpdisc.word.counts.all$keep==T,]


### Reshape the words counts so it's ids by words (counts by focus group)
grpdisc.word.counts.by.id<-as.data.frame.matrix(table(grpdisc.word.counts.cut$Respondent.ID, grpdisc.word.counts.cut$lemma))

## Run Correspondence Analyasis (CA) on the word count data
words.ca.res<-epCA(grpdisc.word.counts.by.id,graphs=F)

################################
### Demographic variables

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

colnames(demogs.counts.out)<-toupper(demogs.labels)

rownames(demogs.counts.out)<-data.in$Respondent.ID

## Run CA on the demographic charateristics counts
demog.ca.res<-epCA(demogs.counts.out, graphs=F)

#tog.words.demogs<-cbind(grpdisc.word.counts.by.id,
#                        demogs.counts.out[match( rownames(grpdisc.word.counts.by.id),rownames(demogs.counts.out)),])

#epCA(tog.words.demogs,graphs = F)


## Run PLS-CA to examine the joint relationship between different demographic variables and words used in their narrative
X<-as.matrix(demogs.counts.out[match( rownames(grpdisc.word.counts.by.id),rownames(demogs.counts.out)),])
Y<-as.matrix(grpdisc.word.counts.by.id)

plsca.res<-plsca_cor(X = X, Y = Y)
taus <- plsca.res$l_full/sum(plsca.res$l_full)

ax1<-1
ax2<-2
plot.constraints<-minmaxHelper(plsca.res$fi, plsca.res$fj, axis1 = ax1, axis2=ax2)
#plot.constraints<-minmaxHelper(plsca.res$p, plsca.res$q, axis1 = ax1, axis2=ax2)

# windows()
# prettyPlot(plsca.res$fi)
# windows()
# prettyPlot(plsca.res$fj)

## Which components to plot


# prettyPlot(plsca.res$fi,x_axis = ax1, y_axis=ax2,constraints = plot.constraints,
#            contributionCircles = T, contributions = plsca.res$u^2 )
# 
# prettyPlot(plsca.res$fj,x_axis = ax1, y_axis=ax2,constraints = plot.constraints,
#            contributionCircles = T, contributions = plsca.res$e^2 )
# 

library(ggplot2)
library(ggrepel)

plot.fi<-ggplot(as.data.frame(plsca.res$fi[,c(ax1,ax2)]),
                aes(V1, V2,label=rownames(plsca.res$fi))) + 
  geom_point(color = "navy",size=5, pch=18) + geom_point(color = "white",size=2, pch=18) +
  xlim(c(plot.constraints$minx, plot.constraints$maxx)) + ylim(c(plot.constraints$miny, plot.constraints$maxy)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.text.x=element_blank(),  axis.ticks.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank()) +
  geom_vline(xintercept = 0,color='darkgray') + geom_hline(yintercept = 0,color='darkgray') +
  geom_label_repel(size=3.5, box.padding = 0.25, point.padding = 0.25, direction = "both",
                   min.segment.length = 0.3 ) +
  xlab(paste0("Component 1. Explained variance: ", round(taus[ax1]*100, digits=1),"%")) +
  ylab(paste0("Component 2. Explained variance: ", round(taus[ax2]*100, digits=1),"%")) +
  ggtitle(paste0(grpdisc.Q, "\nCA: Group Demographics Component Scores")) +
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=16))
        

### Select which words to plot (top 25 words per component)

#contribs<-(plsca.res$v[,c(ax1, ax2)])^2
#expected.contrib<-1/(dim(plsca.res$v)[1])*2.5
#extreme.words<-rowSums(contribs>expected.contrib)
#extreme.words.labels<-rownames(plsca.res$fj)  
#extreme.words.labels[extreme.words==0]<-""

top.n<-30
ax1.top<-names(sort(abs(plsca.res$fj[,ax1]),decreasing = T))[1:top.n]
ax2.top<- names(sort(abs(plsca.res$fj[,ax2]),decreasing = T))[1:top.n]
all.top<-unique(c(ax1.top, ax2.top))

extreme.words.labels<-rownames(plsca.res$fj) 
extreme.words.labels[!(extreme.words.labels %in% all.top)]<-""


plot.fj<-ggplot(as.data.frame(plsca.res$fj[,c(ax1,ax2)]),
                aes(V1, V2, label=extreme.words.labels)) + 
  geom_point(color = "gray36",size=2) +
  xlim(c(plot.constraints$minx, plot.constraints$maxx)) + ylim(c(plot.constraints$miny, plot.constraints$maxy)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.text.x=element_blank(),  axis.ticks.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank()) +
  geom_vline(xintercept = 0,color='darkgray') + geom_hline(yintercept = 0,color='darkgray') +
  geom_label_repel(size=2.5, box.padding = 0.25, point.padding = 0.25, direction = "both",
                   min.segment.length = 0.3 ) +
  xlab(paste0("Component 1. Explained variance: ", round(taus[ax1]*100, digits=1),"%")) +
  ylab(paste0("Component 2. Explained variance: ", round(taus[ax2]*100, digits=1),"%")) +
  ggtitle(paste0(grpdisc.Q, "\nCA: Group Demographics Component Scores")) +
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=16))





