# COVID-19 Vulnerable Populations Group Discussions
Analyses of the [Toronto Office of Recovery and Rebuild Group Discussion data](https://open.toronto.ca/dataset/toronto-office-of-recovery-and-rebuild-group-discussion-vulnerable-populations/) available through [Open Data Toronto](https://www.toronto.ca/city-government/data-research-maps/open-data/)

## Dataset:
From June 24 to July 24, 2020, the City of Toronto contracted Social Planning Toronto (a local non-governmental organization) to conduct additional outreach to equity-seeking or vulnerable residents and groups on their ideas and priorities for response and recovery from the COVID-19 pandemic. This dataset contains the responses (in group discussions) to an online and phone survey conducted as part of this outreach. Forty-one different groups discussed ways in which they were personally impacted by COVID-19, supports and programs they were using prior to the pandemic, and urgent supports that they needed. 

The characteristics of the vulnerable groups included in this dataset are visualized below. The most common traits across discussion groups were that they included racialized individuals, low income/precariously employed/underemployed/unemployed individuals, and women.

<img src="https://github.com/jennyrieck/covid19_group_discuss/blob/main/plots/wordcloud_demogs_Ways.in.which.you.were.personally.impacted.png?raw=true" width="400" />


## Project Aims:
* What are impacts of COVID-19 that are shared across diverse vulnerable populations in Toronto? Identifying common impacts and concerns will inform general policy decisions that can support a broad variety of vulnerable residents. 

* What are impacts of COVID-19 that are unique to different vulerable population characteristics? Identifying unique impacts and concerns will enable a more focused approach to targeting the needs of specific vulnerable groups.

## Methods:
R was used to clean, analyze, and visualize the transcripts from these discussion groups. The following code is included in this repository:

`/R/0_prepText_countWords.R` provides code for downloading, cleaning, and computing word usage frequencies for each discussion question. This code creates one .rda file in `/data/` with two variables: `X.demogs` which is demographic characteristics (i.e., indigenous, low income) for each discussion group and `Y.words` which is word usage frequency.

`/R/1_visualize_word_clouds.R` provides code for generating word clouds that visualize the frequency of word usage for different discussion questions. This allows us to identify those words commonly used across all discussion groups. 

`/R/2_plsca_analyses.R` provides code for running [Partial Least Squares Correspondence Analysis (PLSCA)](https://www.researchgate.net/publication/287797412_Partial_Least_Squares_Correspondence_Analysis_A_Framework_to_Simultaneously_Analyze_Behavioral_and_Genetic_Data/link/584da94608aeb989252641dd/download), a multivariate technique used to identify co-occurences of vulnerable group demographics and word usage for each discussion question. This allows us to identify those words unique to different vulnerable group characteristics.

## Common impacts and urgent supports needed
The word clouds below illustrate the most common words used when discussing the impacts of COVID-19 and the urgent supports needed by vulnerable groups. The size of the word indicates how frequently it was used across different discussion groups.

<p float="left">
  <img src="https://github.com/jennyrieck/covid19_group_discuss/blob/main/plots/wordcloud_words_Ways.in.which.you.were.personally.impacted.png?raw=true" width="400" /> 
  <img src="https://github.com/jennyrieck/covid19_group_discuss/blob/main/plots/wordcloud_words_Urgent.supports.needed.png?raw=true" width="400" /> 
</p>

The most common words used when discussing the personal impact of COVID-19 were: "feel", "family", and "lose", but participants also expressed a high frequency of emotional (e.g., "anxious", "lonely", "sad", "overwhelmed") and financial conerns (e.g., "pay", "income", "employment").

The most common words used when discussing the urgent supports needed were: "people" and "support". Participants also expressed a need for "mental", "community", and "senior" supports.
