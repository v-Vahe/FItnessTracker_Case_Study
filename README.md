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

![Image text](https://github.com/v-Vahe/FItnessTracker_Case_Study/blob/main/figs/report_screenshots.jpg) 
### File structure
***
The project files are organized ia a way that is easy to make changes and try knitting. Meaning that if someone wants to change up the code or just try to understand, it is easy to do so following the instrucitons here. Note that when you knit an rmarkdown document it usually takes a long time to produce all the results from scratch. Hence the dataset manipulations as well as the plot and table generations are done using seperate R scripts and then the results are saved in different folders. Here is the file structure diagram that is helpful in understanding the structure.
![Image text](https://github.com/v-Vahe/FItnessTracker_Case_Study/blob/main/figs/file_structure_diagram.jpg) 
### Technologies
***
The case study was performed using some R packages. Make sure to add the following chunk to [BellaBeat_analysis.Rmd](https://github.com/v-Vahe/FItnessTracker_Case_Study/blob/main/BellaBeay_analysis.Rmd) file) file, and in case you already have some of installed, delete the corresponding rows.

```{r, include=FALSE}
$ # Run sourse code
$ #install.packages('dplyr')
$ #install.packages('lubridate')
$ #install.packages('tidyverse')
$ #install.packages('hms')
$ #install.packages('chron')
$ #install.packages('ggplot2') 
$ #install.packages('GGally')
$ #install.packages('reshape2')
$ #install.packages('grid')
$ #install.packages('gridExtra')
$ #install.packages('kableExtra')
$ #install.packages('knitr')
$ ```
```

In case of any error regarding the R packages, make sure that you install these versions:

**First make sure to have these R and RStudio versions:**
* [R](https://example.com): Version 3.6.3
* [RStudio](https://example.com): Version 1.2.5033

**A list of technologies used within the project:**
* [rmarkdown](https://example.com): Version 2.5 
* [dplyr](https://example.com): Version 1.0.7  
* [lubridate](https://example.com): Version 1.7.10
* [tidyverse](https://example.com): Version 1.3.1 
* [hms](https://example.com): Version 1.1.0 
* [chron](https://example.com): Version 2.3-56
* [ggplot2](https://example.com): Version 3.3.5  
* [GGally](https://example.com): Version 2.1.2 
* [reshape2](https://example.com): Version 1.4.4
* [grid](https://example.com): Version 3.6.3 
* [gridExtra](https://example.com): Version 2.3 
* [kableExtra](https://example.com): Version 1.3.4
* [knitr](https://example.com): Version 1.30 

You can run the following line of code in the console to make sure the versions are matching:

```
$ ```{r, include=FALSE}
$ sessionInfo()
$ ```
```

### Usage
***
After you sort out the packages, make sure that [BellaBeat_analysis.Rmd](https://github.com/v-Vahe/FItnessTracker_Case_Study/blob/main/BellaBeay_analysis.Rmd) runs fine. If there is an error, again make sure to have the right versions. If you still get an error, please let me know.
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
