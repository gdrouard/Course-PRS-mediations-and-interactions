set.seed(2026)

# Shared effect sizes 
b0_cookies <- 500   # baseline cookies/year
b_PRS      <- 150   # cookies increase per 1 SD of PRS_sugar
b_ex       <- -20   # cookies decrease per extra hour of exercise/week
b_int      <- -15   # INTERACTION: exercise buffers the PRS -> cookies effect
sd_cookies <- 60    # residual noise in cookies

c0_happy     <- 70     # baseline happiness (0-100 scale)
c_cookies    <- -0.02  # "path b": more cookies -> slightly lower happiness
c_PRS_direct <- -1.5   # "c'": small residual direct effect of PRS on happiness
sd_happy     <- 8      # residual noise in happiness

###################################################################
# 1 - INDIVIDUALS-ONLY dataset (no family structure, no confounding)

n_individuals <- 5000

PRS_sugar <- as.numeric(scale(rnorm(n_individuals, mean = 0, sd = 1)))

exercise_hours <- rnorm(n_individuals, mean = 5, sd = 2)
exercise_hours[exercise_hours < 0] <- 0

cookies_per_year <- b0_cookies +
  b_PRS * PRS_sugar +
  b_ex * exercise_hours +
  b_int * PRS_sugar * exercise_hours +
  rnorm(n_individuals, mean = 0, sd = sd_cookies)
cookies_per_year[cookies_per_year < 0] <- 0

happiness_score <- c0_happy +
  c_cookies * cookies_per_year +
  c_PRS_direct * PRS_sugar +
  rnorm(n_individuals, mean = 0, sd = sd_happy)
happiness_score <- pmin(pmax(happiness_score, 0), 100)

dat_individuals <- data.frame(
  id               = 1:n_individuals,
  PRS_sugar        = round(PRS_sugar, 3),
  exercise_hours   = round(exercise_hours, 2),
  cookies_per_year = round(cookies_per_year, 1),
  happiness_score  = round(happiness_score, 2)
)

write.csv(dat_individuals, "prs_cookies_happiness_individuals.csv", row.names = FALSE)

#####################################################################
# 2- FAMILIES dataset (1,500 families x 2 siblings, with confounding)

n_families      <- 1500
sibs_per_family <- 2
n_fam_total     <- n_families * sibs_per_family

b_conf_cook  <- 35   # direct effect of family_treat_culture on cookies (confounding path)
c_conf_happy <- 9    # direct effect of family_treat_culture on happiness (confounding path)

family_id <- rep(1:n_families, each = sibs_per_family)
sib_id    <- rep(1:sibs_per_family, times = n_families)

# family_treat_culture: household norms around treats/snacking, shared by
# siblings within a family. Affects cookies_per_year and happiness_score
# directly, but NOT PRS_sugar -- this is purely an assumption-(3)
# confounder (mediator -> outcome), not an assumption-(2) one.
family_treat_culture <- rep(rnorm(n_families, mean = 0, sd = 1), each = sibs_per_family)

# PRS_sugar: plain, independent of family_treat_culture (no population
# stratification).
PRS_sugar_f <- as.numeric(scale(rnorm(n_fam_total, mean = 0, sd = 1)))

exercise_hours_f <- rnorm(n_fam_total, mean = 5, sd = 2)
exercise_hours_f[exercise_hours_f < 0] <- 0

cookies_per_year_f <- b0_cookies +
  b_PRS * PRS_sugar_f +
  b_ex * exercise_hours_f +
  b_int * PRS_sugar_f * exercise_hours_f +
  b_conf_cook * family_treat_culture +
  rnorm(n_fam_total, mean = 0, sd = sd_cookies)
cookies_per_year_f[cookies_per_year_f < 0] <- 0

happiness_score_f <- c0_happy +
  c_cookies * cookies_per_year_f +
  c_PRS_direct * PRS_sugar_f +
  c_conf_happy * family_treat_culture +
  rnorm(n_fam_total, mean = 0, sd = sd_happy)
happiness_score_f <- pmin(pmax(happiness_score_f, 0), 100)

dat_families <- data.frame(
  family_id             = family_id,
  sib_id                = sib_id,
  PRS_sugar             = round(PRS_sugar_f, 3),
  exercise_hours        = round(exercise_hours_f, 2),
  cookies_per_year      = round(cookies_per_year_f, 1),
  happiness_score       = round(happiness_score_f, 2),
  family_treat_culture  = round(family_treat_culture, 3)
)

write.csv(dat_families, "prs_cookies_happiness_families.csv", row.names = FALSE)

