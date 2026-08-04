# PRS in Practice: Interaction, Mediation, and Family-Design Workshop

A hands-on R workshop on using polygenic scores (PRS) in practice, covering interaction analyses, mediation analyses, and a family-design robustness check. Built around a toy dataset linking a "sugar addiction" PRS, exercise, cookie consumption, and happiness.

## Contents

- `simulate_prs_data.R`: generates the two datasets used in the exercises
- `prs_cookies_happiness_individuals.csv`: 5,000 unrelated individuals (used for the interaction and mediation sections)
- `prs_cookies_happiness_families.csv`: 1,500 families of 2 siblings (used for the family-design section)
- `workshop__instructions.pdf`, the exercise sheet: instructions, questions, and R hints for each section

## Getting started

1. Load the datasets in R or run `simulate_prs_data.R` in R to regenerate the datasets.
2. Open `Workshop__instructions.pdf` and work through the exercises in R, using the two CSVs above.
