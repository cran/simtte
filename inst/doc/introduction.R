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

## ----log-survival-example, eval = FALSE---------------------------------------
# set.seed(1)
# result_grid <- sim_tte(
#   pi = lp, mu = -1, coefs = 1.1,
#   time = seq(0.1, 100, by = 0.1),
#   type = "weibull", end_time = 100,
#   event_time_method = "grid"           # default
# )
# 
# set.seed(1)
# result_interp <- sim_tte(
#   pi = lp, mu = -1, coefs = 1.1,
#   time = seq(0.1, 100, by = 0.1),
#   type = "weibull", end_time = 100,
#   event_time_method = "log_survival"   # sub-grid refinement
# )
# 
# # Same seed and trajectory -> identical event/censoring classification.
# identical(result_grid$sim_status, result_interp$sim_status)
# 
# # sim_time can differ only where the crossing falls strictly between
# # two reported grid points.
# head(cbind(grid = result_grid$sim_time, log_survival = result_interp$sim_time))

