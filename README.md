## Table of Contents
1. [General Info](#general-info)
2. [Technologies](#technologies)
3. [Installation](#installation)
4. [Collaboration](#collaboration)
5. [FAQs](#faqs)
### General Info
***
this case study is based on an analysis for BellaBeat digital marketing strategy using data from FitBit users, which are both personal health trackers. The objective is to gain insights from FitBit secondary data, to drive business decisions for another health tracker company called BellaBeat. This data analysis can help guide BellaBeat's marketing strategies, particularly for two of their products Leaf (tracker bracelet) and Time (wellness watch). Some instructions were provided by Google Data Analytics, which is a course on Cursera, developed by Google.

**Deliverables**

1. A clear summary of the business task
2. A description of all data sources used
3. Documentation of any cleaning or manipulation of data
4. A summary of your analysis
5. Supporting visualizations and key findings
6. Your top high-level content recommendations based on your analysis

**Questions to address**

1. What are some trends in smart device usage?
2. How could these trends apply to BellaBeat customers?
3. How could these trends help influence BellaBeat marketing strategy?

Here are a few screenshot for the preview of the report (These are taken from [BellaBeat_analysis.html](https://github.com/v-Vahe/FItnessTracker_Case_Study/blob/main/BellaBeay_analysis.html) file):
![Image text](https://github.com/v-Vahe/FItnessTracker_Case_Study/blob/main/figs/file_structure_diagram.jpg) 
### File structure
***
The project files are organized ia a way that is easy to make changes and try knitting. Meaning that if someone wants to change up the code or just try to understand, it is easy to do so following the instrucitons here. Note that when you knit an rmarkdown document it usually takes a long time to produce all the results from scratch. Hence the dataset manipulations as well as the plot and table generations are done using seperate R scripts and then the results are saved in different folders. Here is the file structure diagram that is helpful in understanding the structure.
![Image text](https://github.com/v-Vahe/FItnessTracker_Case_Study/blob/main/figs/file_structure_diagram.jpg) 
### Technologies
***
In case 

A list of technologies used within the project:
* [R](https://example.com): Version 3.6.3
* [RStudio](https://example.com): Version 1.2.5033
* [rmarkdown](https://example.com): Version 2.5 
* [dplyr](https://example.com): Version 1.0.7  
* [lubridate](https://example.com): Version 1234
* [tidyverse](https://example.com): Version 2.34
* [hms](https://example.com): Version 1234
* [chron](https://example.com): Version 2.34
* [ggplot2](https://example.com): Version 3.3.5  
* [GGally](https://example.com): Version 2.1.2 
* [reshape2](https://example.com): Version 2.34
* [grid](https://example.com): Version 3.6.3 
* [gridExtra](https://example.com): Version 1234
* [kableExtra](https://example.com): Version 1234
* [knitr](https://example.com): Version 1.30 
### Usage
***

After
```
$ ```{r, include=FALSE}
$ # Run sourse code
$ source("./r_scripts/clean_data.R", local = knitr::knit_global())
$ source("./r_scripts/create_metadata.R", local = knitr::knit_global())
$ source("./r_scripts/generate_plots.R", local = knitr::knit_global())
$ ```
```
Side information: To use the application in a special environment use ```lorem ipsum``` to start
### Collaboration
***
Give instructions on how to collaborate with your project.
> Maybe you want to write a quote in this part. 
> Should it encompass several lines?
> This is how you do it.
## FAQs
***
A list of frequently asked questions
1. **This is a question in bold**
Answer to the first question with _italic words_. 
2. __Second question in bold__ 
To answer this question, we use an unordered list:
* First point
* Second Point
* Third point
3. **Third question in bold**
Answer to the third question with *italic words*.
4. **Fourth question in bold**
| Headline 1 in the tablehead | Headline 2 in the tablehead | Headline 3 in the tablehead |
|:--------------|:-------------:|--------------:|
| text-align left | text-align center | text-align right |
