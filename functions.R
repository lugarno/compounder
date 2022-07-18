

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
  cells <- book$Worksheets("sheet1")$Range(cell_range)
  
  # write formulas
  cells[["FormulaArray"]] <- asCOMArray(formulas)
  
  # trigger CapIQ refresh macro
  Sys.sleep(5)
  ex$Run("ThisWorkbook.RefreshCapIQ")
  
  # get results
  Sys.sleep(15)
  result <- unlist(cells[["Value"]])
  
  # close?
  if(close) {
    book$close(FALSE)
    Sys.sleep(1)
    ex$Quit()
    Sys.sleep(1)
    try(system("Taskkill /IM Excel.exe /F"), silent = TRUE)
  }
  
  
  return(result)
  
}

if(FALSE){
  
  library(RDCOMClient)
  
  
  formulas <- c('=@CIQ("NasdaqGS:GOOGL", "IQ_LASTSALEPRICE", "2021-01-02", "LOCAL")')
  GetCapIQ(formulas, close = TRUE)
                
  formulas <- c('=@CIQ("NasdaqGS:GOOGL", "IQ_LASTSALEPRICE", "2021-02-02", "LOCAL")',
                '=@CIQ("NasdaqGS:GOOGL", "IQ_LASTSALEPRICE", "2021-03-10", "LOCAL")')
  GetCapIQ(formulas, close = TRUE)
  
  formulas <- c('=@CIQ("NasdaqGS:GOOGL", "IQ_LASTSALEPRICE", "2021-04-02", "LOCAL")',
                '=@CIQ("NasdaqGS:GOOGL", "IQ_LASTSALEPRICE", "2021-05-10", "LOCAL")',
                '=@CIQ("NasdaqGS:GOOGL", "IQ_LASTSALEPRICE", "2021-06-10", "LOCAL")')
  GetCapIQ(formulas, close = TRUE)
}