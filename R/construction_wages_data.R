library(tidyverse)
library(statcanR)
library(plyr)

construction_wages_raw <- statcan_download_data("18-10-0139-01", lang = "eng")

construction_wages_raw |> 
  select(
    REF_DATE, 
    GEO, 
    TRADE = `Construction trades`,
    WAGE_TYPE = `Type of wage rates`,
    VALUE
    ) |> 
  mutate(
    YEAR = year(REF_DATE),
    MONTH = month(REF_DATE)
    ) |> 
  filter(
    WAGE_TYPE == "Basic construction union wage rates"
  ) |> 
  View()




w <- sd(x)/sqrt(100)
qt(0.05, 99)

bind_cols(mean(x) - abs(qt(0.025, 99)) * w, mean(x) + abs(qt(0.025, 99)) * w)
bind_cols(mean(x) - abs(qnorm(0.025)) * w, mean(x) + abs(qnorm(0.025, 99)) * w)

v <- c()
for (i in 1:1000) {
  x <- rnorm(1000, mean = 4, sd = 20)
  v[i] <- (mean(x)-4)/sd(x) + qnorm(0.95)*(1-20/sd(x))
}
hist(v)

po <- function(x, theta=3, n=100) {
  (2*n*(x^(2*n-1)))/(theta^(2*n))
}

v <- c()
for (i in 1:1000) {
  t <- (runif(10))^(1/10)*4
  v[i] <- max(t)
}
hist(v)

t <- c()
for (i in 1:1000) {
  x <- rnorm(1000000, 4, 11)
  t[i] <- (mean(x)-4) + qnorm(0.95) * (sd(x)-11)
}
hist(t)
