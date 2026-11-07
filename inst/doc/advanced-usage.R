## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(simtte)

## ----explore-pi, eval = FALSE-------------------------------------------------
# data_sim <- explore_pi_tq_surv(
#   pi = seq(-3, 3, by = 0.1),
#   mu = -1,
#   shape = seq(0.9, 1.1, by = 0.1),
#   end_time = 200,
#   type = "weibull"
# )
# head(data_sim)

## ----plot-pi, eval = FALSE----------------------------------------------------
# library(ggplot2)
# ggplot(data_sim, aes(x = exp(lp), y = survdiff_tq)) +
#   geom_line(aes(color = factor(shape), group = shape)) +
#   scale_x_log10() +
#   labs(
#     x = "Hazard Ratio",
#     y = expression(Delta ~ "Survival at" ~ t[50]),
#     color = "Shape"
#   ) +
#   geom_vline(xintercept = 1, linetype = 2) +
#   geom_hline(yintercept = 0, linetype = 2) +
#   theme_bw()

## ----custom-------------------------------------------------------------------
# Example with a mock survival data frame (no mrgsolve needed)
set.seed(123)
mrg_output <- data.frame(
  ID = rep(1:5, each = 100),
  time = rep(seq(0.1, 10, length.out = 100), 5),
  p11 = rep(exp(-0.3 * seq(0.1, 10, length.out = 100)), 5)
)
result <- sim_tte_df(mrg_output, surv_var = "p11", id_var = "ID",
  time_var = "time")
head(result)

## ----log-survival-------------------------------------------------------------
set.seed(7)
result_grid <- sim_tte_df(mrg_output, event_time_method = "grid")

set.seed(7)
result_interp <- sim_tte_df(mrg_output, event_time_method = "log_survival")

# Event/censoring classification is identical for the same trajectory
# and the same random draws -- interpolation only refines *where*
# within an already-identified interval the event falls.
identical(result_grid$sim_status, result_interp$sim_status)

cbind(
  ID           = result_grid$ID,
  status       = result_grid$sim_status,
  grid         = result_grid$sim_time,
  log_survival = result_interp$sim_time
)

## ----arms, eval = FALSE-------------------------------------------------------
# set.seed(42)
# n_per_arm <- 50
# times <- seq(0.1, 50, by = 0.1)
# 
# # Control arm
# lp_ctrl <- matrix(rep(0, n_per_arm), nrow = n_per_arm)
# ctrl <- sim_tte(pi = lp_ctrl, mu = -1, coefs = 1.1,
#   time = times, type = "weibull", end_time = 50)
# ctrl$arm <- "Control"
# 
# # Treatment arm (lower hazard)
# lp_trt <- matrix(rep(-0.5, n_per_arm), nrow = n_per_arm)
# trt <- sim_tte(pi = lp_trt, mu = -1, coefs = 1.1,
#   time = times, type = "weibull", end_time = 50)
# trt$arm <- "Treatment"
# 
# combined <- rbind(ctrl, trt)
# head(combined)

