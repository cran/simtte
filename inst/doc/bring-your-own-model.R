## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(simtte)

## ----tte-model-source---------------------------------------------------------
my_model <- "
$PARAM CL = 1, V = 20, KA = 1
$CMT DEPOT CENT
$ODE
dxdt_DEPOT = -KA*DEPOT;
dxdt_CENT = KA*DEPOT - (CL/V)*CENT;
$CAPTURE CL KA
"

## ----tte-model-convert--------------------------------------------------------
tm <- tte_model(my_model, hazard = "H0 * exp(lp + beta * (CENT/V))",
  params = list(H0 = 0.01, beta = 0.05))
tm

## ----tte-model-code-----------------------------------------------------------
cat(tm$code, sep = "\n")

## ----tte-model-sim------------------------------------------------------------
dose <- data.frame(ID = 1:30, time = 0, cmt = 1, amt = 100, evid = 1)
sim_tm <- sim_tte_ode(model = tm, n = 30, end = 20, delta = 2, data = dose,
  seed = 1)
head(sim_tm$events)

## ----tte-model-omega----------------------------------------------------------
my_model_omega <- "
$PARAM TVCL = 1, TVV = 20, KA = 1
$OMEGA @labels ETA_CL ETA_V
0 0
$CMT DEPOT CENT
$MAIN
double CL = TVCL*exp(ETA_CL);
double V  = TVV*exp(ETA_V);
$ODE
dxdt_DEPOT = -KA*DEPOT;
dxdt_CENT = KA*DEPOT - (CL/V)*CENT;
"
tm_omega <- tte_model(my_model_omega,
  hazard = "H0 * exp(lp + beta * (CENT/V))",
  params = list(H0 = 0.01, beta = 0.05))
sim_tm_omega <- sim_tte_ode(model = tm_omega, omega = diag(c(0.09, 0.16)),
  n = 30, data = dose, end = 20, delta = 2, seed = 1)
head(sim_tm_omega$events)

## ----hazard-boundary----------------------------------------------------------
tm_emax <- tte_model(my_model, hazard = "H0 * (CENT / (EC50 + CENT))",
  params = list(H0 = 0.01, EC50 = 5))
sim_emax <- sim_tte_ode(model = tm_emax, n = 30, end = 20, delta = 2,
  data = dose, seed = 1)
head(sim_emax$events)

