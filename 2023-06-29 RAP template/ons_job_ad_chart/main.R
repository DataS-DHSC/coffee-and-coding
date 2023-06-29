
# Project launch file
# Source this file to run code


# Load global packages ----------------------------------------------------

# check librarian package management installed
if (!requireNamespace("librarian")) install.packages("librarian", quiet = TRUE)

# use suppress to prevent build warnings
# note can install from github
suppressWarnings(
  librarian::stock(
    DataS-DHSC/DHSClogger,
    onsr,
    tidyverse,
    DataS-DHSC/DHSCcolours
  )
)


# Setup logging -----------------------------------------------------------

logger <- DHSClogger::get_dhsc_logger()

# set threshold of console log to information and above
logger$set_threshold("log.console", "INFO")


# Call main code ----------------------------------------------------------

logger$info("[Begin]")

# add source of run script and entry point to code below
source("./R/run_analysis.R", local = TRUE)
run_analysis()

logger$info("[End]")
