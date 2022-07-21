# tables ------------------------------------------------------------------


datatable_std2 <- function(df, scrollY_override = FALSE, ordering = TRUE,col_freeze_left = 2,  ...) {
  DT::datatable(df,
                rownames = FALSE,
                extensions = c('Buttons', 'FixedColumns'),
                options = list(autoWidth=FALSE,
                               ordering = ordering,
                               # columnDefs = list(list(className = "dt-center", targets = 1:(ncol(df)-1))),
                               paging=FALSE,
                               dom = 'rtBp',
                               scrollY = if(!scrollY_override & (nrow(df) > 12)) { "500px"} else {NULL},
                               scrollX = "500px",
                               fixedColumns = list(leftColumns = col_freeze_left),
                               buttons = c('copy', 'csv', 'excel')),...) %>% 
    formatStyle(col_freeze_left:(ncol(df)+col_freeze_left-1), textAlign = 'right')
  
}


get_unit <- function(x) {
  as.character(x) %>% strsplit("_") %>% lapply(function(x) x[2]) %>% unlist()
}

strip_unit <- function(x) {
  out <- as.character(x) %>% strsplit("_") %>% lapply(function(x) x[1]) %>% unlist()
  
  # preserve factor ordering
  if(is.ordered(x)){
    out <- factor(out, levels = strip_unit(levels(x)))
  }
  
  return(out)
}


gen_data_table <- function(stock_code_i){
  
  
  dt_temp1 <- dt_stats_fy[stock_code == stock_code_i,
                           .(fy_code,
                             
                             `Revenue Per Share_$`,
                             `Gross Profit Per Share_$`,
                             `Statutory Net Profit Per Share_$`,
                             `Free Cash Flow Per Share_$`,
                             
                             `Revenue_$M`,
                             `Gross Profit_$M`,
                             `Statutory Net Profit_$M`,
                             `Free Cash Flow_$M`,
                             `Diluted Shares Outstanding_M`,
                             
                             `Gross Profit Margin_%`,
                             `Net Profit Margin_%`,
                             `Return on Invested Capital_%`,
                             
                             `Cash Conversion Ratio_X`,
                             
                             `Debt/Equity_%`,
                             `Interest Coverage_X`,
                             
                             `Revenue Per Share 5yr CAGR_%`,
                             `Free Cash Flow Per Share 5yr CAGR_%`,
                             
                             `FCF Yield_%`,
                             `FCF Yield 3yr Rolling Average_%`,
                             `FCF Yield 5yr Rolling Average_%`,
                             
                             `EV / EBITDA (Annual Average)_X`,
                             `EV / EBITDA (Annual Average) 3yr Rolling Avearge_X`,
                             `EV / EBITDA (Annual Average) 5yr Rolling Avearge_X`,
                             
                             `Dividend Yield_%`,
                             `Dividend Yield 3yr Rolling Avearge_%`,
                             `Dividend Yield 5yr Rolling Avearge_%`
                             )]
  

  dt_temp_long <- melt.data.table(dt_temp1, id.vars = "fy_code",variable.name = "metric_unit")
  dt_temp_long[, metric_unit := ordered(metric_unit)]

  
  dt_temp_long[, value_unit := get_unit(metric_unit)]
  dt_temp_long[, metric := strip_unit(metric_unit)]
  
  
  dt_temp_long[value_unit %in% c("$","$M","M"), value_formatted := prettyNum(round(value,0), big.mark = "," )]
  dt_temp_long[value_unit %in% c("$","$M") & value < 0, value_formatted := gsub("^-","",value_formatted)]
  dt_temp_long[value_unit %in% c("$","$M") & value < 0, value_formatted := paste0("(", value_formatted, ")")]
  dt_temp_long[value_unit %in% c("$","$M") & value == 0, value_formatted := "-"]
  
  dt_temp_long[value_unit %in% c("%","X"), value_formatted := format(round(value,1L), big.mark = ",", nsmall = 1L )]
  
  dt_temp_long[, fy_code_ordered := ordered(fy_code, rev(sort(unique(fy_code))))]
  dt_temp_long[, value_unit_display := tolower(value_unit)]
  
  dt_temp <- dcast.data.table(dt_temp_long, metric + value_unit_display ~ fy_code_ordered, value.var = "value_formatted")
  
  # temporary section headers
  dt_temp[, section := c("Data", rep("", 8),
                              "Profitability", rep("", 2),
                              "Cash Generation/Conversion",
                              "Financial Stability/Leverage","",
                              "Growth","",
                              "Valuation", rep("",8))]
  setcolorder(dt_temp, "section")
  
  setnames(dt_temp, c("metric","value_unit_display","section"), c("","",""))
  
  datatable_std2(dt_temp,ordering = FALSE,col_freeze_left =3)
}
