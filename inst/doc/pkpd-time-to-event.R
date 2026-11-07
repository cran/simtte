## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(simtte)

## ----weibull-baseline---------------------------------------------------------
sim <- sim_tte_ode(model = "weibull", param = list(mu = -1, shape = 1.5),
  n = 30, end = 20, delta = 2, seed = 1)
head(sim$events)

## ----sim-tte-ode-models-------------------------------------------------------
sim_tte_ode_models()

## ----irm1-dose----------------------------------------------------------------
dose <- data.frame(ID = 1:30, time = 0, cmt = 1, amt = 100, evid = 1)
sim_pkpd <- sim_tte_ode(model = "irm1_hazard",
  param = list(H0 = 0.01, beta_r = 1), n = 30, end = 20, delta = 2,
  data = dose, seed = 1)
head(sim_pkpd$events)

## ----weibull-covariate--------------------------------------------------------
baseline <- data.frame(age = rnorm(30, 50, 10),
  arm = factor(rep(c("control", "treated"), 15)))
sim_cov <- sim_tte_ode(model = "weibull", param = list(mu = -1, shape = 1.5),
  n = 30, end = 20, delta = 2, covariates = baseline,
  formula = ~ age + arm, beta = c(age = 0.01, armtreated = -0.5),
  seed = 1)
head(sim_cov$events)

## ----weibull-covariate-legacy-------------------------------------------------
cov <- data.frame(time = c(0, 10), sex = c(0, 1))
sim_legacy <- sim_tte_ode(model = "weibull", param = list(mu = -1, shape = 1.5),
  n = 30, end = 20, delta = 2, covariates = cov, beta = c(sex = 0.8),
  seed = 1)

## ----dose-and-covariate-------------------------------------------------------
dose_regimen <- mrgsolve::expand.ev(ID = 1:6, amt = 100, cmt = 1,
  ii = 12, addl = 3, time = 0)
age <- data.frame(age = c(40, 50, 60, 70, 80, 90))
sim_dose_cov <- sim_tte_ode(model = "pk_hazard",
  param = list(H0 = 0.01, beta_cp = 0.02), n = 6, end = 48, delta = 2,
  data = dose_regimen, covariates = age, formula = ~ age,
  beta = c(age = 0.01), seed = 1, keep_trajectory = TRUE)
head(sim_dose_cov$events)

## ----dose-and-covariate-check-------------------------------------------------
t0 <- subset(sim_dose_cov$trajectory, time == 0)
cbind(t0[, c("ID", "CP", "HAZ")], age = age$age)

## ----irm1-omega---------------------------------------------------------------
om <- matrix(0.09, dimnames = list("CL", "CL"))
sim_bsv <- sim_tte_ode(model = "irm1_hazard", omega = om,
  param = list(H0 = 0.01, beta_r = 1), n = 30, end = 20, delta = 2,
  data = dose, seed = 1)
head(sim_bsv$events)

## ----irm1-idata---------------------------------------------------------------
set.seed(1)
n <- 30
CL_i <- 1 * exp(rnorm(n, 0, sqrt(0.09)))  # population CL = 1, log-normal BSV
idata <- data.frame(ID = seq_len(n), CL = CL_i)
head(idata)

sim_idata <- sim_tte_ode(model = "irm1_hazard", idata = idata,
  param = list(H0 = 0.01, beta_r = 1), end = 20, delta = 2, data = dose,
  seed = 1)
head(sim_idata$events)

## ----shape-guardrail----------------------------------------------------------
msgs <- capture.output(
  sim_small_shape <- sim_tte_ode(model = "weibull",
    param = list(mu = -1, shape = 0.01), n = 5, end = 10, delta = 1,
    seed = 1),
  type = "message"
)
msgs

## ----cox-via-mspline, eval = requireNamespace("survival", quietly = TRUE)-----
trt <- data.frame(ID = 1:400, time = 0, trt = rep(0:1, 200))
sim <- sim_tte_ode(model = "mspline", knots = c(5, 10, 15),
  coefs = c(0.2, 1, 0.5, 1.5, 0.8, 0.3), param = list(mu = -1.5),
  n = 400, end = 20, delta = 1, covariates = trt, beta = c(trt = -0.5),
  seed = 1)
ev <- merge(sim$events, trt[c("ID", "trt")], by = "ID")
fit <- survival::coxph(survival::Surv(sim_time, sim_status) ~ trt, data = ev)
cbind(estimate = coef(fit), confint(fit))

## ----legacy-api---------------------------------------------------------------
set.seed(42)
lp <- matrix(rnorm(20, 0, 0.5), nrow = 20)
result <- sim_tte(pi = lp, mu = -1, coefs = 1.1,
  time = seq(0.1, 20, by = 0.5), type = "weibull", end_time = 20)
head(result)

