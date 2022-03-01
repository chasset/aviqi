# Help

## Dependency and Reproducibility

Our aim is to deliver reproducible results. All software needed for this session will be built in a virtual machine based on docker.

If Docker is already installed on your machine, build the VM:

```bash
docker compose build
```

## Debug environment

If you want to explore and test code, use the RStudio environment of the virtual machine:

```bash
bash rstudio.sh
```

It will open your favorite browser and ask you for username (ubuntu) and password (ubuntu).

## Export the final file

In order to get the final report, you must define your job in an `.env` file and how to load data tables in a `sites-definition.csv` file. After that, just execute:

```bash
bash month-report.sh
```

### .env

```bash
# Target month
YEAR=2021
MONTH=1

# Output file
OUTPUTFILENAME="result.csv"

# Skip or stop policies
# 1 'Skip all errors',
# 2 'Stop if unsual values are encountered',
# 3 'Stop if extreme values are encountered',
# 4 'Stop if one file is missing for a site'
CHOSENPOLICY=1

# Where are all files?
DATAFOLDER="data"

# Sites definition with files parameters
SITES="sites-definition.csv"
```

### sites-definition.csv

site | catalog | details | orders | delimiter | hasIds | isCents
-----|---------|---------|--------|-----------|--------|---------
lane.com | RÉFÉRENTIEL PRODUITS | ORDER_ITEMS | TRANSACTION | C | F | T
lyons-evans.com | products | détail commandes | commande | T | T | F 
ross-armstrong.com | products | détail commandes | commandes | T | F | F
wiley-ruiz.com | CATALOGUE | DÉTAIL COMMANDES | COMMANDE | S | F | F
fake1.com | CATALOGUE | DÉTAIL COMMANDES | COMMANDE | S | F | F
fake2.com | CATALOGUE | DÉTAIL COMMANDES | COMMANDE | S | F | F
