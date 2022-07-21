# Compounder website

Generates a website tracking financial metrics of specified stocks based on automated data acquisition from S&P Capital IQ.

## Status

-   [x] CapIQ data acquisition automated
-   [ ] First test case retrieving GOOGL
    -   [x] Retrieve once-only and FY metrics
    -   [x] Generate test webpage with all data
        -   [x] Data
            -   [x] Per share values
            -   [x] Gross values
        -   [x] Profitability
        -   [x] Cash Generation/Conversion
        -   [x] Financial Stability/Leverage
        -   [x] Growth
        -   [x] Valuation
    -   [x] Add units to table
    -   [ ] Table formatting
        -   [x] Placeholder sections
        -   [ ] Show/hide sections
    -   [ ] Data section to per-share with gross values as tooltip?
-   [ ] Add other stocks
    -   [ ] Dynamic units based on currency

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

Edit `data_provided/stocks.csv`
