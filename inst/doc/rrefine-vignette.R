## ---- echo = FALSE, message = FALSE, warning = FALSE--------------------------
library(rrefine)

## ---- echo=TRUE, eval = FALSE-------------------------------------------------
#  install.packages("rrefine")

## ---- echo=TRUE, eval = FALSE-------------------------------------------------
#  # install.packages("devtools")
#  devtools::install_github("vpnagraj/rrefine")

## ---- echo=TRUE, eval = FALSE-------------------------------------------------
#  library(rrefine)

## ---- echo=FALSE, results='asis'----------------------------------------------
knitr::kable(lateformeeting)

## ---- eval = FALSE, echo = TRUE, warning = FALSE, message=FALSE---------------
#  write.csv(lateformeeting, file = "lateformeeting.csv", row.names = FALSE)
#  refine_upload(file = "lateformeeting.csv", project.name = "lfm_cleanup", open.browser = TRUE)

## ---- eval = FALSE, echo = TRUE, warning = FALSE, message=FALSE---------------
#  refine_add_column(new_column = "dotw_allcaps",
#                    base_column = "what.day.whas.it",
#                    value = "grel:value",
#                    project.name = "lfm_cleanup")
#  refine_to_upper(column_name = "dotw_allcaps", project.name = "lfm_cleanup")
#  refine_export(project.name = "lfm_cleanup")$dotw_allcaps

## ----echo=FALSE---------------------------------------------------------------
toupper(lfm_clean$dotw)

## ---- eval = FALSE, echo = TRUE, warning = FALSE, message=FALSE---------------
#  refine_remove_column(column = "dotw_allcaps", project.name = "lfm_cleanup")

## ---- eval = FALSE, echo = TRUE, warning = FALSE, message=FALSE---------------
#  lfm_clean <- refine_export(project.name = "lfm_cleanup")
#  lfm_clean

## ---- echo = FALSE, eval = TRUE, warning = FALSE, message=FALSE---------------
knitr::kable(lfm_clean)

## ---- eval = FALSE, echo = TRUE, warning = FALSE, message=FALSE---------------
#  refine_delete(project.name = "lfm_cleanup")

