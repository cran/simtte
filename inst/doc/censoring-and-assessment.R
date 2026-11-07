## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(simtte)

## ----baseline-sim-------------------------------------------------------------
sim_uncensored <- sim_tte_ode(model = "exponential",
  param = list(H0 = 0.05), n = 200, end = 30, delta = 2, seed = 1)
table(sim_uncensored$events$sim_reason)

## ----censoring-basic----------------------------------------------------------
censored <- add_censoring(sim_uncensored$events,
  censoring = list(dist = "exponential", rate = 0.02), end = 30, seed = 2)
table(censored$sim_reason)

## ----censoring-arg------------------------------------------------------------
sim_censored <- sim_tte_ode(model = "exponential", param = list(H0 = 0.09),
  n = 200, end = 30, delta = 2,
  censoring = list(dist = "exponential", rate = 0.02), seed = 1)
table(sim_censored$events$sim_reason)

## ----censoring-rate-for-------------------------------------------------------
# 1. Solve: what rate gives ~20% independently censored, given this
#    model's own event-time scale?
event_times <- sim_uncensored$events$sim_time[
  sim_uncensored$events$sim_status == 1]
rate_20pct <- censoring_rate_for(event_times, target = 0.2)
rate_20pct

# 2. Redraw: apply that rate to a larger cohort.
check <- sim_tte_ode(model = "exponential", param = list(H0 = 0.09),
  n = 2000, end = 30, delta = 2,
  censoring = list(dist = "exponential", rate = rate_20pct), seed = 1)

# 3. Check: did it land close to 20%?
mean(check$events$sim_reason == "censored")

## ----interval-basic-----------------------------------------------------------
visits <- c(0, 5, 10, 15, 20, 25, 30)
interval <- add_interval_censoring(sim_censored$events, visits = visits)
head(interval[, c("ID", "sim_time", "sim_status", "sim_reason",
  "sim_time_left", "sim_time_right")])

## ----interval-survfit, eval = requireNamespace("survival", quietly = TRUE)----
right_for_surv <- ifelse(is.infinite(interval$sim_time_right), NA,
  interval$sim_time_right)
fit <- survival::survfit(survival::Surv(time = sim_time_left,
  time2 = right_for_surv, type = "interval2") ~ 1,
  data = data.frame(sim_time_left = interval$sim_time_left,
    right_for_surv = right_for_surv))
summary(fit, times = visits)

## ----left-censoring-----------------------------------------------------------
ev <- data.frame(ID = 1:3, sim_time = c(5, 15, 25),
  sim_status = c(1L, 1L, 0L))
add_interval_censoring(ev, visits = c(0, 10))

## ----interval-jitter----------------------------------------------------------
sched <- visit_schedule(n = 200, every = 4, end = 24, jitter = 1, seed = 1)
head(sched)

sim_jittered <- sim_tte_ode(model = "exponential", param = list(H0 = 0.05),
  n = 200, end = 24, delta = 2, visits = list(every = 4, jitter = 1),
  seed = 1)
head(sim_jittered$events[, c("sim_time", "sim_status", "sim_time_left",
  "sim_time_right")])

## ----thin-visits--------------------------------------------------------------
realized <- thin_visits(sched, p_miss = 0.1, p_dropout = 0.05, seed = 2)
nrow(sched) - nrow(realized) # visits lost to missed/dropout
out <- add_interval_censoring(sim_censored$events, visits = realized)
head(out[, c("sim_time", "sim_status", "sim_time_left", "sim_time_right")])

## ----informative-bias, message = FALSE, eval = requireNamespace("survival", quietly = TRUE)----
rate <- 0.08
sim_small <- sim_tte_ode(model = "exponential", param = list(H0 = rate),
  n = 800, end = 24, delta = 2, seed = 1)
base_sched <- visit_schedule(n = 800, every = 3, end = 24, seed = 1)
base_sched$ID <- sim_small$events$ID[base_sched$ID]
visit_times <- seq(0, 24, by = 3)
analytical_surv <- exp(-rate * visit_times)

fit_surv <- function(schedule) {
  out <- add_interval_censoring(sim_small$events, visits = schedule)
  right <- ifelse(is.infinite(out$sim_time_right), NA, out$sim_time_right)
  fit <- survival::survfit(survival::Surv(time = sim_time_left, time2 = right,
    type = "interval2") ~ 1,
    data = data.frame(sim_time_left = out$sim_time_left, right = right))
  summary(fit, times = visit_times, extend = TRUE)$surv
}

c1_sched <- thin_visits(base_sched, p_miss = 0.3, seed = 2)
c2_sched <- visit_schedule_informative(base_sched, sim_small$events,
  end = 24, p_miss_base = 0.1, miss_near_event = list(window = 3, p = 0.9),
  seed = 2)

data.frame(time = visit_times,
  truth = round(analytical_surv, 3),
  c1_non_informative = round(fit_surv(c1_sched), 3),
  c2_informative = round(fit_surv(c2_sched), 3))

