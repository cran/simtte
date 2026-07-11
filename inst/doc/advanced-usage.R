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

## ----custom, eval = FALSE-----------------------------------------------------
# # Assume 'mrg_output' is the output of an mrgsim() call with a 'p11' column
# # result <- sim_tte_df(mrg_output, surv_var = "p11", id_var = "ID")

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

