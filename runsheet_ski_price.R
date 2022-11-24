library(httr)
library(xml2)
library(tidyverse)
# Quelle

quelle <- "https://ski.ticketcorner.ch/de/"


################################################################################

#Skigebiete und deren Nummern


# 
# Arosa-Lenzerheide     -  3
# 
# Engadin St.Moritz     - 21
# 
# Engelberg-Titlis      - 27
# 
# Gstaad-Region         -  2
# 
# Laax                  - 50


# keine tickets auf ticketcorner

# Aletsch Arena         - 
# Mattherhorn Zermatt   - 

################################################################################

# get names of skigebiete und die passenden nummern dazu


dta_ski <- tibble(skigebietname = c("arosa_lenzerheide",
                                       "engadin_st_moritz",
                                       "engelberg_titlis",
                                       "gstaad_region",
                                       "laax"),
                     skigebiet_nr = c(3,21,27,2,50))


# load get_ski_price-function

source("function_get_ski_price.R")






# test

# get_ski_price(skigebiet_name = "arosa_lenzerheide",
#               skigebiet_nr = 3,
#               enddatum = 31)




walk2(dta_ski$skigebietname, dta_ski$skigebiet_nr,
      function(x, y) get_ski_price(skigebiet_name = x,
                                    skigebiet_nr = y, 
                                       enddatum = 16)) # enddatum beim eigentlichen durchgang weglassen; default = 16. April 2023 (saisonschluss der
                                                        # meisten Skigebiete)
