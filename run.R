
# Libraries ---------------------------------------------------------------

if(FALSE)
{
  remotes::install_github("BSchamberger/RDCOMClient")
}


library(RDCOMClient)
library(data.table)



# Load stocks -------------------------------------------------------------



dt_stocks <- fread("data_provided/stocks.csv")



# Specify metrics ---------------------------------------------------------



