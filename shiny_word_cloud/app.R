library(shiny)
library(wordcloud2)
library(RColorBrewer)

questions <- c("Ways in which you were personally impacted" = "../data/word_counts_Ways.in.which.you.were.personally.impacted.rda",
               "Supports and programs you were accessing prior to COVID-19" = "../data/word_counts_Supports..programs.and.services.you.were.a.rda",
               "Urgent supports needed" = "../data/word_counts_Urgent.supports.needed.rda")

demogs<- c("All Groups" = "ALL", "Indigenous" = "INDIGENOUS","Black" = "BLACK","Racialized"= "RACIALIZED","Youth"= "YOUTH","Women"="WOMEN",
           "Seniors"="SENIORS","LGTBQ2S+"="LGBTQ2S.","Newcomers"="NEWCOMERS.","Persons w/ Disabilities"="DISABILITI",
           "Low-Income"="LOW.INCOME","Homeless" = "HOMELESSNE","Underhoused"="UNDERHOUSE","Consumer Survivors"="CONSUMER.S",
           "Addiction Challenges"="ADDICTION.","Gender-Based Violence Survivors"="GENDER.VIO","Incarcerated"="INCARCERAT",
           "Religious or Cultural Discrimination"="CULTURAL.O")

getWordFreq <- function(question, group){
    load(question)
    
    if(group!="ALL"){
        
        if(sum(X.demogs[,group]==1)==1){
            ### reformat if only one row/group for the chosen demog
            Y.words<-t(as.matrix(Y.words[X.demogs[,group]==1,]))
            
        }else{
            Y.words<-Y.words[X.demogs[,group]==1,]
        }
    }else{
        ### To examine common words across all groups, word counts are binarized, as to not overweight 
        ### words used in high frequency by only one group:
        Y.words[Y.words>0]<-1
    }
    ### Count word frequency 
    full.word.cloud.mat<-data.frame(word = colnames(Y.words),freq=colSums(Y.words))
    return(full.word.cloud.mat)
}

# Define UI for application
ui <- fluidPage(
    
    # Application title
    titlePanel("COVID-19 Vulnerable Populations Group Discussions"),
    helpText("During the summer of 2020, Social Planning Toronto conducted group discussions with different vulnerable groups in Toronto to 
            gauge the impact of the COVID-19 pandemic and recovery priorities."),
    helpText(a("Full discussion transcripts are available through Open Data Toronto", target="_blank",href="https://open.toronto.ca/dataset/toronto-office-of-recovery-and-rebuild-group-discussion-vulnerable-populations/") ),
    sidebarLayout(
        # Sidebar with a slider and selection inputs
        sidebarPanel("This app generates word clouds from these discussion groups to illustrate 
            the most common words for each discussion topic. Larger words were used more frequently in the discussion.", 
                     selectInput("selectionQues", "Choose a discussion topic:",
                                 choices = questions),
                     "Word clouds can also be generated based on specific vulnerable group characteristics.",
                     selectInput("selectionGroup", "Choose a group characteristic:",
                                 choices = demogs),
                     
                     actionButton("update", "Refresh"),
                     # hr(),
                     #    sliderInput("freq","Minimum Frequency:",
                     #               min = 1,  max = 15, value = 2),
                     #   sliderInput("max","Maximum Number of Words:",
                     #               min = 1,  max = 50,  value = 30)
        ),
        
        ## Show Word Cloud
        #mainPanel(
        #    plotOutput("plot")
        #)
        wordcloud2Output('wordcloud2')
    )
)

# Define server logic
server <- function(input, output) {
    terms <- reactive({
        input$update
        isolate({
            getWordFreq(input$selectionQues, input$selectionGroup)
        })
    })
    
    #output$plot <- renderPlot({
    #    v <- terms()
    #    
    # wordcloud(words = v$word, freq = v$freq, min.freq = input$freq,           
    #           max.words=input$max, random.order=FALSE, rot.per=0, scale=c(3,.25),           
    #           colors=brewer.pal(8, "Dark2"))
    
    #})
    output$wordcloud2 <- renderWordcloud2({
        v <- terms()
        # wordcloud2(demoFreqC, size=input$size)
        wordcloud2(v, size=1)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
