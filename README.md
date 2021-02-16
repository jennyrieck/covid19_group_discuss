# COVID-19 Vulnerable Populations Group Discussions
Analyses of the [Toronto Office of Recovery and Rebuild Group Discussion data](https://open.toronto.ca/dataset/toronto-office-of-recovery-and-rebuild-group-discussion-vulnerable-populations/) available through [Open Data Toronto](https://www.toronto.ca/city-government/data-research-maps/open-data/)

- [Dataset](#dataset)
- [Project Aims](#project-aims)
- [Methods](#methods)
- [Common Impacts and Concerns](#common-impacts-and-concerns-across-groups)
- [Unique Impacts and Concerns](#unique-impacts-and-concerns)

# Dataset
From June 24 to July 24, 2020, the City of Toronto contracted Social Planning Toronto (a local non-governmental organization) to conduct additional outreach to equity-seeking or vulnerable residents and groups on their ideas and priorities for response and recovery from the COVID-19 pandemic. This dataset contains the responses (in group discussions) to an online and phone survey conducted as part of this outreach. Forty-one different groups discussed ways in which they were personally impacted by COVID-19, supports and programs they were using prior to the pandemic, and urgent supports that they needed. 

The characteristics of the vulnerable groups included in this dataset are visualized below. The most common traits across discussion groups were that they included racialized individuals, low income/precariously employed/underemployed/unemployed individuals, and women.

<img src="./plots/wordcloud_demogs_Ways.in.which.you.were.personally.impacted.png?raw=true" width="400" />


# Project Aims
* What are impacts of COVID-19 that are shared across diverse vulnerable populations in Toronto? Identifying common impacts and concerns will inform general policy decisions that can support a broad variety of vulnerable residents. 

* What are impacts of COVID-19 that are unique to different vulnerable population characteristics? Identifying unique impacts and concerns will enable a more focused approach to targeting the needs of specific vulnerable groups.

# Methods
R was used to clean, analyze, and visualize the transcripts from these discussion groups. The following code is included in this repository:

`/R/0_prepText_countWords.R` provides code for downloading, cleaning, and computing word usage frequencies for each discussion question. This code creates one .rda file in `/data/` with two variables: `X.demogs` which is demographic characteristics (i.e., indigenous, low income) for each discussion group and `Y.words` which is word usage frequency.

`/R/1_visualize_word_clouds.R` provides code for generating word clouds that visualize the frequency of word usage for different discussion questions. This allows us to identify those words commonly used across all discussion groups. 

`/R/2_plsca_analyses.R` provides code for running [Partial Least Squares Correspondence Analysis (PLSCA)](https://www.researchgate.net/publication/287797412_Partial_Least_Squares_Correspondence_Analysis_A_Framework_to_Simultaneously_Analyze_Behavioral_and_Genetic_Data/link/584da94608aeb989252641dd/download), a multivariate technique used to identify co-occurrences of vulnerable group demographics and word usage for each discussion question. This allows us to identify those words unique to different vulnerable group characteristics.

# Common Impacts and Concerns Across Groups
The word clouds below illustrate the most common words used when discussing the impacts of COVID-19 and the urgent supports needed by vulnerable groups. The size of the word indicates how frequently it was used across different discussion groups. [Click here to explore word clouds in an interactive app](https://jennyrieck.shinyapps.io/covid19_discuss_word_cloud/)

<p float="left">
  <img src="./plots/wordcloud_words_Ways.in.which.you.were.personally.impacted.png?raw=true" width="400" /> 
  <img src="./plots/wordcloud_words_Urgent.supports.needed.png?raw=true" width="400" /> 
</p>

The most common words used when discussing the personal impact of COVID-19 were: "feel", "family", and "lose", but participants also expressed a high frequency of emotional (e.g., "anxious", "lonely", "sad", "overwhelmed") and financial concerns (e.g., "pay", "income", "employment").

The most common words used when discussing the urgent supports needed were: "people" and "support". Participants also expressed a need for "mental", "community", and "senior" supports.

# Unique Impacts and Concerns
Partial Least Squares Correspondence Analysis (PLSCA) is a multivariate technique to identify the joint relationships between vulnerable group characteristics and words used to discuss COVID-19. PLSCA places emphasis on less frequent words ("diabetes") or demographic characteristics  (e.g., "indigenous"), whereas frequent words (e.g., "covid") or demographic characteristics common across groups (e.g., "low income") have less contribution. The results are visualized on factor maps in which frequent words or demographic characteristics will be near the origin (i.e., center) and  unique words or demographic characteristics will be far from the origin. The two factor maps are directly comparable such the locations of different words (i.e., left side of the plot) corresponds to those demographic characteristics that uniquely used those words.

## Personal Impacts
<p float="left">
  <img src="./plots/plsca_res_fi_ax12_Ways.in.which.you.were.personally.impacted.png?raw=true" width="400" /> 
  <img src="./plots/plsca_res_fj_ax12_Ways.in.which.you.were.personally.impacted.png?raw=true" width="400" /> 
</p>

Underhoused people, persons with disabilities, seniors, and newcomers (left side of factor space) express unique concerns regarding health ("diabetes", "respiratory problems", "heart problem") and social services ("food bank", "community agency"). Consumer survivors and incarcerated people (top middle of factor space) use the words "store", "apply", "ttc", "sleep", "die" with greater frequency when discussing personal impacts. Culturally oppressed, racialized persons, women, and youth (right side of factor space) discuss impacts regarding "finance", "routine", "church", "spirituality", and "finance".
