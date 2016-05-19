# Script to extract market pricing for VW Tiguan (by year)

# Load libraries
library(rvest)
library(dplyr)
library(ggplot2)

# Links from Dubizzle, for VW Tiguan, no filters, from 19-May-2016
page_links <- list("https://dubai.dubizzle.com/motors/used-cars/volkswagen/tiguan/?site=2&s=MT&rc=140&c1=1604&c2=1614&price__gte=&price__lte=&year__gte=&year__lte=&kilometers__gte=&kilometers__lte=&seller_type=&keywords=&is_basic_search_widget=0&is_search=1&places__id__in=Start+typing+here&places__id__in=&added__gte=&auto_agent=",
                   "https://dubai.dubizzle.com/motors/used-cars/volkswagen/tiguan/?page=2&price__gte=&price__lte=&year__gte=&year__lte=&kilometers__gte=&kilometers__lte=&seller_type=&keywords=&is_basic_search_widget=0&is_search=1&places__id__in=Start+typing+here&places__id__in=&added__gte=&auto_agent=",
                   "https://dubai.dubizzle.com/motors/used-cars/volkswagen/tiguan/?page=3&price__gte=&price__lte=&year__gte=&year__lte=&kilometers__gte=&kilometers__lte=&seller_type=&keywords=&is_basic_search_widget=0&is_search=1&places__id__in=Start+typing+here&places__id__in=&added__gte=&auto_agent=",
                   "https://dubai.dubizzle.com/motors/used-cars/volkswagen/tiguan/?page=4&price__gte=&price__lte=&year__gte=&year__lte=&kilometers__gte=&kilometers__lte=&seller_type=&keywords=&is_basic_search_widget=0&is_search=1&places__id__in=Start+typing+here&places__id__in=&added__gte=&auto_agent=")

# Initialize Vectors
year <- vector(mode = "character")
kilometer <- vector(mode = "character")
price <- vector(mode = "character")

# Loop through pages
for (i in 1:4) {
      
      # Save page content
      page <- read_html(page_links[[i]])
      
      # Extract car features
      content <- page %>%
            html_nodes("ul.features li") %>%
            html_text()
      
      # Extract prices
      content_price <- page %>%
            html_nodes("div#results-list div.block.item-title div.price") %>%
            html_text()
      
      # Clean the pricing data
      content_price <- trimws(gsub("\n", "", content_price))
      content_price <- gsub("AED ", "", content_price)
      content_price <- gsub(",", "", content_price)
      
      # Store price data in vector
      if (length(price) > 0) {
            price <- append(price, content_price)
      } else {
            price <- content_price
      }
      
      # Store model year data in vector
      if (length(year) > 0) {
            year <- append(year, grep("^Year:", content, value = TRUE))
      } else {
            year <- grep("^Year:", content, value = TRUE)
      }
      
      # Store kilometer data in vector
      if (length(kilometer) > 0) {
            kilometer <- append(kilometer, grep("^Kilometers:", content, value = TRUE))
      } else {
            kilometer <- grep("^Kilometers:", content, value = TRUE)
      }
}

# Final Data Cleansing
year <- as.numeric(gsub("Year: ", "", year))
kilometer <- as.numeric(gsub("Kilometers: ", "", kilometer))
price <- as.numeric(price)

# Save results in data frame
x <- data.frame(year = year, kilometer = kilometer, price = price)

# Show data frame summary
summary(x)

# Show boxplot
ggplot(x, aes(as.factor(year), price)) + geom_boxplot() + geom_jitter(width = 0.2)

# Remove outliers
min(x$price)  # outliers are priced at 20 kAED
x <- subset(x, price > 20000)

# Scatter Plot
ggplot(x, aes(year, price)) +
      geom_point() +
      geom_smooth(color = "green") +
      xlab("Model Year") +
      ylab("Price (AED)") +
      ggtitle("Price Decline")

# Price Decline over 3 years, on average
mean_2016 <- mean(subset(x, year == 2016, select = price)$price)
mean_2013 <- mean(subset(x, year == 2013, select = price)$price)
decline_pct <- round((mean_2016 - mean_2013) / mean_2016 * 100, 2)
decline_pct

summary(x)

quantile(subset(x, year == 2014, select = price)$price, probs = )