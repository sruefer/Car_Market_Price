# Car Market Price
Determine current car market price with R script through web scraping and data visualization

## Problem Statement
For selling my car I wanted to know what is the approximate market price. My usual way to determine pricing is to go to a car website, filter by criteria that match my car and have a look through the offered models and their pricing. Based on my rough estimate, I then would set a "negotiable" selling price for my car and hope for the best. When negotiating the price later with potential buyers, I always felt I am leaving money on the table (and yes, one reason is poor negotiation skills!). 

I was wondering: if I understand the market better, would I be in a better position to sell my car at a realistic price, hence managing my own expectations while at the same time being able to show to buyers why I can confidently demand the asking price.

## Solution Approach
I tried first to come up with Excel graphs that show me the price decline curve (over model year). Just to extract the data was a pain, and the graph was not showing all the details I wanted. 

So as I am teaching myself data science, I thought, why not write a script in R to achieve a better result? Below are the steps to create the results.

- Go to the car website and save the link results from my (rough) selection (4 pages)
- Use the `rvest` package to extract the data from HTML; for the sake of simplicity I only extracted price, kilometers and model year.
- Clean the data and save it into a data frame
- Create meaningful graphs with the `ggplot2` package.

## Notes
Please check out the `report.md` file for details on results and R script.

Why only 3 variables? Because there was not much data (only 96 observations); additional filters would have resulted in either less observations, or observations with missing values. 