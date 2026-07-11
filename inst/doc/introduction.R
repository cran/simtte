## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(simtte)

## ----weibull-example, eval = FALSE--------------------------------------------
# set.seed(42)
# lp <- matrix(rnorm(50, 0, 0.5), nrow = 50)
# result <- sim_tte(
#   pi = lp,
#   mu = -1,
#   coefs = 1.1,
#   time = seq(0.1, 100, by = 0.1),
#   type = "weibull",
#   end_time = 100
# )
# head(result)

## ----ms-example, eval = FALSE-------------------------------------------------
# data("ms_data")
# lp <- matrix(runif(nrow(ms_data$basis)), nrow = nrow(ms_data$basis))
# result <- sim_tte(
#   pi = lp,
#   mu = ms_data$mu,
#   basis = ms_data$basis,
#   coefs = ms_data$coefs,
#   time = ms_data$time,
#   type = "ms"
# )
# head(result)

