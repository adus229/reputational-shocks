# Study on Reputational Shocks in the Corporate World

## Table of Contents
- [Study on Reputational Shocks in the Corporate World](#study-on-reputational-shocks-in-the-corporate-world)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Project Objectives](#project-objectives)
  - [Case Study: Ouïghour Forced Labor Scandal](#case-study-ouïghour-forced-labor-scandal)
  - [Data Description](#data-description)
  - [Methodology](#methodology)
  - [Results](#results)
  - [Conclusion](#conclusion)
  - [How to Run the Analysis](#how-to-run-the-analysis)

## Introduction
The research focuses on evaluating the impact of a reputational shock on companies. Specifically, it examines the Ouïghour forced labor scandal that surfaced in March 2020, which accused over eighty companies of using forced Ouïghour labor.

## Project Objectives
The main goals of this study are:
- To evaluate the impact of reputational shocks on the stock prices of companies implicated in the Ouïghour forced labor scandal.
- To analyze how companies' stock prices respond to such reputational shocks compared to their competitors.
- To investigate how companies that committed to ceasing the use of forced labor were affected.

## Case Study: Ouïghour Forced Labor Scandal
The case study revolves around the scandal in which numerous companies were accused of using Ouïghour labor against their will. The analysis evaluates the effects of this reputational shock on the stock prices of these companies and their competitors. The study utilizes econometric evaluation methods, such as difference-in-differences and Student's t-tests, to measure the impact.

## Data Description
The dataset used in this analysis includes:
- **Company financial data**: Stock prices, revenue, and number of employees (2019-2020) for the affected and unaffected companies.
- **Date range**: The analysis focuses on the period from February 18, 2020, to March 18, 2020.
- **Source**: The data was primarily sourced via web scraping from Yahoo Finance, capturing the daily stock prices of the companies involved.

Two groups were studied:
- **Treatment Group**: Companies listed in the scandal.
- **Control Group**: Competitors not listed in the scandal but operating in similar sectors.

## Methodology
The analysis employed two primary econometric techniques:
1. **Difference-in-Differences (DiD)**:
   - This method compares the stock price variations between the treatment and control groups before and after the publication of the list on March 3, 2020.
   - The aim was to isolate the impact of the scandal on the stock prices of the listed companies while controlling for other factors.
2. **Analysis of Abnormal Returns**:
   - Used to measure if the stock returns post-scandal were significantly different from expected returns.
   - Student's t-tests were applied to assess whether the changes in stock prices were statistically significant.

## Results
- **Difference-in-Differences Analysis**: 
  - The publication of the list had a significant negative impact on the stock prices of the companies mentioned in the scandal. Firms in the textile and automotive sectors were the most affected.
- **Abnormal Returns**:
  - The method revealed mixed results, with no statistically significant impact across all firms, suggesting that market reactions varied.

## Conclusion
The study indicates that reputational shocks, such as the Ouïghour labor scandal, can have a detrimental effect on the stock prices of implicated companies, particularly in certain sectors. The findings emphasize the importance of maintaining a positive corporate reputation, especially in the age of social media where information spreads rapidly.

## How to Run the Analysis
1. Clone this repository to your local machine.
   ```bash
   git clone https://github.com/yourusername/reputational-shocks-analysis.git
