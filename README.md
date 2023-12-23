# stock-market

The opensource stock market databas

## Overview

This repository serves as a database for stock market exchanges, providing a
collection of symbols retrieved from various global stock markets. The task of
obtaining a comprehensive list of symbols for stock exchanges is known to be
challenging, but here you'll find a compilation of symbols that have been
managed to be retrieved, albeit with some difficulty.

## Exchanges

The following table provides an overview of major global stock marketplaces:

The exchanges list

<!-- BEGIN exchanges -->

```text
                       _____              _                                        _  _       _
                      |  ___|            | |                                      | |(_)     | |
                      | |__  __  __  ___ | |__    __ _  _ __    __ _   ___  ___   | | _  ___ | |_
                      |  __| \ \/ / / __|| '_ \  / _` || '_ \  / _` | / _ \/ __|  | || |/ __|| __|
                      | |___  >  < | (__ | | | || (_| || | | || (_| ||  __/\__ \  | || |\__ \| |_
                      \____/ /_/\_\ \___||_| |_| \__,_||_| |_| \__, | \___||___/  |_||_||___/ \__|
                                                                __/ |
                                                          ┈┈┈
A summary of the main global stock marketplaces.
                                                          ┄┄┄

exchanges

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EXCHANGE   MARKET   name                                   nb_indices   nb_equities
────────   ──────   ────────────────────────────────────   ──────────   ───────────
NYSE       XNYS     NEW YORK STOCK EXCHANGE                821          1052
EURONEXT   XPAR     EURONEXT PARIS                         101          381
EURONEXT   XOSL     OSLO BORS                              75           213
EURONEXT   XAMS     EURONEXT AMSTERDAM                     139          147
EURONEXT   XBRU     EURONEXT BRUSSELS                      43           120
EURONEXT   XLIS     EURONEXT LISBON                        31           39
EURONEXT   XDUB     IRISH STOCK EXCHANGE                   10           23
EURONEXT   ALXP     EURONEXT GROWTH PARIS                               290
EURONEXT   ETLX     EUROTLX                                             438
EURONEXT   BGEM     BORSA ITALIANA GLOBAL EQUITY MARKET                 379
EURONEXT   MTAH     BORSA ITALIANA - TRADING AFTER HOURS                588
EURONEXT   EXGM     EURONEXT GROWTH MILAN                               266
EURONEXT   XOAS     EURONEXT EXPAND OSLO                                16
EURONEXT   XMIL     BORSA ITALIANA S.P.A.                               235
EURONEXT   MERK     EURONEXT GROWTH - OSLO                              108
EURONEXT   XMLI     EURONEXT ACCESS PARIS                               167
EURONEXT   ENXL     EURONEXT ACCESS LISBON                              13
EURONEXT   XESM     EURONEXT GROWTH DUBLIN                              15
EURONEXT   MLXB     EURONEXT ACCESS BRUSSELS                            8
EURONEXT   VPXB     VENTES PUBLIQUES BRUSSELS                           6
EURONEXT   ALXB     EURONEXT GROWTH BRUSSELS                            4
NASDAQ     XNAS     NASDAQ                                              6427
SSE        XSHG     SHANGHAI STOCK EXCHANGE                409
SZSE       XSHE     SHENZHEN STOCK EXCHANGE                198
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

╴╴╴
dataset:
  metadatas:
    generated_with: 'cfwf@0.5.0 - https://github.com/badele/cfwf'
  title: Exchanges list
tables:
  - tablename: exchanges
```

<!-- END exchanges -->

## Symbols

You can see the symbols on the [database/symbols](database/symbols) page
