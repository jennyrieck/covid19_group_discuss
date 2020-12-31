#### LOAD PACKAGES

### GPLS by Derek Beaton for Partial Least Squares Correspondence Analysis to jointly analyze demographic counts table and word counts table 
#install_github("derekbeaton/gsvd")
#install_github("derekbeaton/GPLS",subdir = "Package",force=TRUE)
library(GPLS)
## ExPosition to run Correspondence Analyasis of single count tables
library(ExPosition)
## GG for pretty plots
library(ggplot2)
library(ggrepel)


##### Run Partial Least Squares Correspondence Analysis to jointly analyze
##### two count tables (demographic counts and word counts)

grpdisc.Q <-'Ways.in.which.you.were.personally.impacted'
#grpdisc.Q <-'Supports..programs.and.services.you.were.accessing.before.COVID.19'
#grpdisc.Q <- 'Urgent.supports.needed'


load(paste0('../data/word_counts_', substr(grpdisc.Q,1,42), '.rda'))

## Run Correspondence Analyasis (CA) on the word count data
#words.ca.res<-epCA(grpdisc.word.counts.by.id,graphs=F)


## Run PLS-CA to examine the joint relationship between different demographic variables and words used in their narrative
plsca.res<-plsca_cor(X = X.demogs, Y = Y.words)
taus <- plsca.res$l_full/sum(plsca.res$l_full)

ax1<-1
ax2<-2
plot.constraints<-minmaxHelper(plsca.res$fi, plsca.res$fj, axis1 = ax1, axis2=ax2)
#plot.constraints<-minmaxHelper(plsca.res$p, plsca.res$q, axis1 = ax1, axis2=ax2)

## Quick and dirty Pretty Plotting
# prettyPlot(plsca.res$fi,x_axis = ax1, y_axis=ax2,constraints = plot.constraints,
#            contributionCircles = T, contributions = plsca.res$u^2 )
# 
# prettyPlot(plsca.res$fj,x_axis = ax1, y_axis=ax2,constraints = plot.constraints,
#            contributionCircles = T, contributions = plsca.res$e^2 )
# 

### Prettier GGPLOTS

plot.fi<-ggplot(as.data.frame(plsca.res$fi[,c(ax1,ax2)]),
                aes(V1, V2,label=rownames(plsca.res$fi))) + 
  geom_point(color = "navy",size=5, pch=18) + geom_point(color = "white",size=2, pch=18) +
  xlim(c(plot.constraints$minx, plot.constraints$maxx)) + ylim(c(plot.constraints$miny, plot.constraints$maxy)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.text.x=element_blank(),  axis.ticks.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank()) +
  geom_vline(xintercept = 0,color='darkgray') + geom_hline(yintercept = 0,color='darkgray') +
  geom_text(aes(label=rownames(plsca.res$fi)),nudge_x=0, nudge_y=.05) +
  #geom_label_repel(size=3.5, box.padding = 0.25, point.padding = 0.25, direction = "both",
                   #min.segment.length = 0.3 ) +
  xlab(paste0("Component 1. Explained variance: ", round(taus[ax1]*100, digits=1),"%")) +
  ylab(paste0("Component 2. Explained variance: ", round(taus[ax2]*100, digits=1),"%")) +
  ggtitle(paste0(grpdisc.Q, "\nCA: Group Demographics Component Scores")) +
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=16))


png(file=paste0("../plots/plsca_res_fi_ax",ax1,ax2,'_',substr(grpdisc.Q,1,42),".png"),height=500,width=500)
print(plot.fi)
dev.off()


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

png(file=paste0("../plots/plsca_res_fj_ax",ax1,ax2,'_',substr(grpdisc.Q,1,42),".png"),height=500,width=500)
print(plot.fj)
dev.off()
