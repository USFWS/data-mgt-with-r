################################################################################
# This script is a template for the general structure of R scripts used for    #
# I&M biometric analyses. This first header should describe what the script    #
# does, describe relationships to other relevant project scripts, and          #
# list which input files it needs and which output it produces. This header    #
# also contains name and e-mail adress of the author, and the date created and #
# last modified.                                                               #
#                                                                              #
# Author: First and last name <firstname_lastname@fws.gov>                     #
# Date created: YYYY-MM-DD                                                     #
# Date last edited: YYYY-MM-DD                                                 #
################################################################################


# Setup ------------------------------------------------------------------------

# For eMac
INWTUtils::rmPkgs()  # Clean up search path
.libPaths("C:/Users/jlaufenberg/Documents/R/win-library/3.4") # Specify personal R package library

# Load packages
library(packagename)

# Source external scripts
source("directory_path/script_foo.R")


# 1 Load data -----------------------------------------------------------------
## ---- load_data  

example_vector <- 1:3  # snake_case for ordinary object names


# 2 Prepare data ---------------------------------------------------------------
## ---- prep_data  


