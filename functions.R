

GetCapIQ <- function(formula, close = FALSE) {
  
  # kill existing excel processes
  try(system("Taskkill /IM Excel.exe /F"), silent = TRUE)
  
  # launch excel and find workbook COM
  system('explorer "template.xlsm')
  Sys.sleep(10)
  ex <- getCOMInstance("Excel.Application")
  book <- ex$ActiveWorkbook()
  
  # specify cells
  cell_range <- paste0("A1:A", length(formulas))
  cells <- book$Worksheets("sheet1")$Range("A1:A2")
  
  # write formulas
  cells[["FormulaArray"]] <- asCOMArray(formulas)
  
  # trigger CapIQ refresh macro
  Sys.sleep(5)
  ex$Run("ThisWorkbook.RefreshCapIQ")
  
  # get results
  Sys.sleep(10)
  result <- unlist(cells[["Value"]])
  
  # close?
  if(close) {
    ex$Quit()
    try(system("Taskkill /IM Excel.exe /F"), silent = TRUE)
  }
  
  
  return(result)
  
}

if(FALSE){
  
  formulas <- c('=@CIQ("NasdaqGS:GOOGL", "IQ_LASTSALEPRICE", "2021-01-02", "LOCAL")',
                '=@CIQ("NasdaqGS:GOOGL", "IQ_LASTSALEPRICE", "2021-01-10", "LOCAL")')
  
  
  GetCapIQ(formulas, close = TRUE)
}