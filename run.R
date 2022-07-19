
# Libraries ---------------------------------------------------------------

if(FALSE)
{
  remotes::install_github("BSchamberger/RDCOMClient")
}


library(RDCOMClient)
library(data.table)



# Set dates ---------------------------------------------------------------


date_update <- format(Sys.Date(), "%Y-%m-%d")

fy_all <- 2001:2021

dt_fy <- data.table(fy = fy_all)
dt_fy[, `:=`(fy_code = paste0("FY", fy),
             date_fy_start = paste0(fy, "-01-01"),
             date_fy_end = paste0(fy, "-12-31"))]


# Functions ---------------------------------------------------------------


source("functions.R")


# Load stocks -------------------------------------------------------------


dt_stocks <- fread("data_provided/stocks.csv")


# Load metrics ------------------------------------------------------------


dt_metrics <- fread("data_provided/metrics.csv")

dt_metrics[, metric_formula := gsub("^\"\"","", metric_formula)]
dt_metrics[, metric_formula := gsub("\"\"$","", metric_formula)]
dt_metrics[, metric_formula := gsub("\"\"","\"", metric_formula)]


# Prep data retrieval -----------------------------------------------------


dt_retrieve_once <- CJ(stock_code = dt_stocks$stock_code,
                       metric_name =  dt_metrics[metric_freq=="once"]$metric_name)

dt_retrieve_fy <- CJ(stock_code = dt_stocks$stock_code,
                         metric_name =  dt_metrics[metric_freq=="fy"]$metric_name,
                         fy_code = dt_fy$fy_code)

dt_retrieve <- rbindlist(list(dt_retrieve_once,
                              dt_retrieve_fy),
                         fill = TRUE)


dt_retrieve[dt_fy, on = .(fy_code), `:=`(date_fy_start = i.date_fy_start,
                                         date_fy_end = i.date_fy_end)]

dt_retrieve[dt_metrics, on = .(metric_name), `:=`(metric_formula = i.metric_formula,
                                                  metric_freq = i.metric_freq)]

dt_retrieve[, row_id := seq(.N)]


dt_retrieve[, metric_formula := gsub("PARAM_stock_code",stock_code, metric_formula), by = row_id]
dt_retrieve[, metric_formula := gsub("PARAM_date_update",date_update, metric_formula), by = row_id]
dt_retrieve[, metric_formula := gsub("PARAM_FY",fy_code, metric_formula), by = row_id]
dt_retrieve[, metric_formula := gsub("PARAM_date_fy_start",date_fy_start, metric_formula), by = row_id]
dt_retrieve[, metric_formula := gsub("PARAM_date_fy_end",date_fy_end, metric_formula), by = row_id]


# Retrieve CapIQ ----------------------------------------------------------


dt_retrieve[, metric_value := GetCapIQ(metric_formula, close = TRUE)]


# TODO need to make cash negative again?


dt_retrieve[metric_freq == "once"]
