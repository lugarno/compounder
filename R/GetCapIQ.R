
GetCapIQ <- function(formulas, close_excel = FALSE, silent_system = TRUE) {
  
  message("Starting CapIQ data retrieval\n - Any Excel instances will be terminated.\n - Do not interact with Windows before data retrieval confirmation message.")
  
  
  n_cells <- length(formulas)
  
  
  # check number of commands
  row_limit <- 1048576L
  if(n_cells==0L) stop("No formulas provided")
  if(n_cells > row_limit) stop("Number of CapIQ queries exceed limit")
  
  # kill existing excel processes
  try(system("Taskkill /IM Excel.exe /F",ignore.stderr = silent_system, ignore.stdout = silent_system), silent = silent_system)
  
  # launch excel and find workbook COM
  system('explorer "template.xlsm')
  
  message("Waiting for Excel start", appendLF = FALSE)
  
  ex <- NULL
  while(class(ex) != "COMIDispatch"){
    Sys.sleep(2)
    message(".", appendLF = FALSE)
    ex <- try(getCOMInstance("Excel.Application", force = FALSE), silent = TRUE)
  }
  
  book <- NULL
  while(is.null(book)){
    Sys.sleep(2)
    message(".", appendLF = FALSE)
    book <- ex$ActiveWorkbook()
  }
  message("ready", appendLF = TRUE)
  
  
  # specify cells
  cell_range <- paste0("A1:A", n_cells)
  cells <- book$Worksheets("sheet1")$Range(cell_range)
  
  cell_test_capiq <- book$Worksheets("sheet1")$Range(paste0("B1:B",n_cells))
  cell_test_csv <- book$Worksheets("sheet1")$Range("C1")
  
  # write formulas and check
  cells[["FormulaArray"]] <- asCOMArray(formulas)
  cell_test_capiq[["FormulaArray"]] <- asCOMArray(paste0('=IF(A',1,'="#PEND",0,1)')) # it's unclear why this works... and the expected correct formula doesn't
  
  # trigger CapIQ refresh macro
  message("Waiting for CapIQ", appendLF = FALSE)
  Sys.sleep(2)
  ex$Run("ThisWorkbook.RefreshCapIQ")
  
  # get results when ready
  have_results <- FALSE
  while(!have_results) {
    message(".", appendLF = FALSE)
    Sys.sleep(1)
    result_check <- suppressWarnings(suppressMessages(try(all(unlist(cell_test_capiq[["value"]])==1), silent = TRUE)))
    have_results <- if(class(result_check) == "logical") {
      result_check
    } else {
      FALSE
    }
    
  }
  
  # cell_test_capiq[["FormulaArray"]] <- asCOMArray("")
  message("done", appendLF = TRUE)
  
  # save to csv
  message("Retrieving results", appendLF = FALSE)
  if(close_excel) message(" and closing Excel", appendLF = FALSE)
  
  path_out <- "data_derived/capiq_temp.csv"
  if(file.exists(path_out)) unlink(path_out)
  
  cell_test_csv[["value"]] <- 0
  
  ex$Run("ThisWorkbook.ExportAsCSV")
  
  while(cell_test_csv[["value"]] != 1) {
    message(".", appendLF = FALSE)
    Sys.sleep(1)
  }
  cell_test_csv[["value"]] <- ""
  
  result <- fread(path_out, header=FALSE)$V1
  if(file.exists(path_out)) unlink(path_out)
  
  
  # close?
  if(close_excel) {
    book$close(FALSE)
    message(".", appendLF = FALSE)
    Sys.sleep(1)
    message(".", appendLF = FALSE)
    ex$Quit()
    Sys.sleep(1)
    message(".", appendLF = FALSE)
    try(system("Taskkill /IM Excel.exe /F",ignore.stderr = silent_system, ignore.stdout = silent_system), silent = silent_system)
  }
  
  message("done", appendLF = TRUE)
  
  return(result)
  
}

if(FALSE){
  
  library(RDCOMClient)
  
  
  formulas <- c('=@CIQ("NasdaqGS:GOOGL", "IQ_LASTSALEPRICE", "2021-01-02", "LOCAL")')
  GetCapIQ(formulas, close_excel = TRUE)
  
  formulas <- c('=@CIQ("NasdaqGS:GOOGL", "IQ_LASTSALEPRICE", "2021-02-02", "LOCAL")',
                '=@CIQ("NasdaqGS:GOOGL", "IQ_LASTSALEPRICE", "2021-03-10", "LOCAL")')
  GetCapIQ(formulas, close_excel = TRUE)
  
  formulas <- c('=@CIQ("NasdaqGS:GOOGL", "IQ_LASTSALEPRICE", "2021-04-02", "LOCAL")',
                '=@CIQ("NasdaqGS:GOOGL", "IQ_LASTSALEPRICE", "2021-05-10", "LOCAL")',
                '=@CIQ("NasdaqGS:GOOGL", "IQ_LASTSALEPRICE", "2021-06-10", "LOCAL")')
  GetCapIQ(formulas, close_excel = TRUE)
}
