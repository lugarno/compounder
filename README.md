# Compounder website

Generates a website tracking financial metrics of specified stocks based on automated data acquisition from S&P Capital IQ.

## Status

-   [x] CapIQ data acquisition automated
-   [x] First test case retrieving GOOGL
    -   [x] Retrieve once-only and FY metrics
    -   [ ] Generate test webpage
        -   [ ] Data
            -   [x] Gross values
            -   [ ] Per share as default
            -   [ ] Add units to table
        -   [ ] Profitability
        -   [ ] Cash Generation/Conversion
        -   [ ] Financial Stability/Leverage
        -   [ ] Growth
        -   [ ] Valuation
-   [ ] Add other stocks
-   [ ] Automate website refresh
-   [ ] Add licence

## Software requirements

-   Windows
-   R
-   [RDCOMClient package forked by BSchamberger](https://github.com/BSchamberger/RDCOMClient)
-   Excel
-   [S&P Capital IQ Pro Office Tools](https://www.capitaliq.spglobal.com/web/client?auth=inherit#apps/capitaliqprooffice)

## Steps before running

-   Open `template.xlsxm` and enable macros
-   Sign into the S&P Excel plugin

# Important notes on interaction with Excel and CapIQ

-   Excel is controlled from R to retrieve CapIQ data
-   Any running instances of Excel will be automatically terminated when accessing CapIQ
-   Do not interact with Excel or switch to another window while Excel is being accessed, this may cause errors

## How to add/remove stocks

Edit the file `data_provided/stocks.csv`
