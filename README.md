# Compounder website

Generates a website tracking financial metrics of specified stocks based on automated data acquisition from S&P Capital IQ.

## Software requirements

-   Windows
-   R
-   [RDCOMClient package forked by BSchamberger](https://github.com/BSchamberger/RDCOMClient)
-   Excel
-   [S&P Capital IQ Pro Office and S&P Capital IQ Pro Office Tools](https://www.capitaliq.spglobal.com/web/client?auth=inherit#apps/capitaliqprooffice)

## Before running

-   Open `template.xlsxm` and enable macros
-   Sign into the S&P Excel plugin

## How to add/remove stocks

Edit the file `data_provided/stocks.csv`

## Status

-   [x] CapIQ data acquisition automated
-   [ ] Test case retrieving GOOGL
    -   [ ] Retrieve all financial metrics
    -   [ ] Generate webpage
-   [ ] Add other stocks
-   [ ] Automate website refresh
