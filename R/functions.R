# tables ------------------------------------------------------------------


datatable_std2 <- function(df, scrollY_override = FALSE, ordering = TRUE, ...) {
  DT::datatable(df,
                rownames = FALSE,
                extensions = c('Buttons'),
                options = list(autoWidth=FALSE,
                               ordering = ordering,
                               # columnDefs = list(list(className = "dt-center", targets = 1:(ncol(df)-1))),
                               paging=FALSE,
                               dom = 'rtBp',
                               scrollY = if(!scrollY_override & (nrow(df) > 12)) { "500px"} else {NULL},
                               scrollX = "500px",
                               buttons = c('copy', 'csv', 'excel')),...) %>% 
    formatStyle(1:(ncol(df)-1), textAlign = 'right')
  
}




gen_data_table <- function(stock_code_i){
  
  
  dt_temp1 <- dt_stocks_fy[stock_code == stock_code_i,
                           .(fy_code,
                             Revenue,
                             `Gross Profit`,
                             `Statutory Net Profit`,
                             `Free Cash Flow`,
                             `Diluted Shares Outstanding`)]
  
  dt_temp_long <- melt.data.table(dt_temp1, id.vars = "fy_code")
  dt_temp_long[, value_formatted := prettyNum(round(value,0), big.mark = ",", )]
  dt_temp_long[value < 0, value_formatted := paste0("(", value_formatted, ")")]
  dt_temp_long[value == 0, value_formatted := "-"]
  
  dt_temp_long[, fy_code_ordered := ordered(fy_code, rev(sort(unique(fy_code))))]
  
  
  dt_temp <- dcast.data.table(dt_temp_long, variable ~ fy_code_ordered, value.var = "value_formatted")
  setnames(dt_temp, "variable", " ")
  
  datatable_std2(dt_temp,ordering = FALSE)
}