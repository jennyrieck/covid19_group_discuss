# COVID-19 Vulnerable Populations Group Discussions
Analyses of the [Toronto Office of Recovery and Rebuild Group Discussion data](https://open.toronto.ca/dataset/toronto-office-of-recovery-and-rebuild-group-discussion-vulnerable-populations/) available through [Open Data Toronto](https://www.toronto.ca/city-government/data-research-maps/open-data/)

## Dataset and Code:
From June 24 to July 24, 2020, the City of Toronto contracted Social Planning Toronto (a local non-governmental organization) to conduct additional outreach to equity-seeking or vulnerable residents and groups on their ideas and priorities for response and recovery from the COVID-19 pandemic. This dataset contains the responses (in group discussions) to an online and phone survey conducted as part of this outreach. Forty-one different groups discussed ways in which they were personally impacted by COVID-19, supports and programs they were using prior to the pandemic, and urgent supports that they needed. 

R was used to clean, analyze, and visualize the transcripts from these discussion groups. 

`/R/0_prepText_countWords.R` provides code for downloading, cleaning, and computing word usage frequencies for each discussion question. This code creates one .rda file in `/data/` with two variables: `X.demogs` which is demographic characteristics (i.e., indigenous, low income) for each discussion group and `Y.words` which is word usage frequency.

`/R/1_visualize_word_clouds.R`

`/R/2_plsca_analyses.R`


## Project Aims:
* How do different vulnerable populations in Toronto describe how they have been affected by COVID-19?
* What supports do different vulnerable populations need?

## Word Clouds
The word clouds below illustrates the most common vulnerable population demographic characteristics for the disucssion groups and the most common words used when discussing different questions .

<p float="left">
  <img src="https://github.com/jennyrieck/covid19_group_discuss/blob/main/plots/wordcloud_demogs_Ways.in.which.you.were.personally.impacted.png?raw=true" width="400" />
  <img src="https://github.com/jennyrieck/covid19_group_discuss/blob/main/plots/wordcloud_words_Ways.in.which.you.were.personally.impacted.png?raw=true" width="400" /> 
 <img src="https://github.com/jennyrieck/covid19_group_discuss/blob/main/plots/wordcloud_words_Supports..programs.and.services.you.were.a.png?raw=true" width="400" /> 
  <img src="https://github.com/jennyrieck/covid19_group_discuss/blob/main/plots/wordcloud_words_Urgent.supports.needed.png?raw=true" width="400" /> 
</p>

The most common traits across discussion groups were that they included racialized individuals, low income/precariously employed/underemployed/unemployed individuals, and women. The most common words used when discussing the personal impact of COVID-19 were: "feel", "family", and "lose".
