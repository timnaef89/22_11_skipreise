library(httr)
library(xml2)

# Quelle

quelle <- "https://ski.ticketcorner.ch/de/"


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
# 


dta_ski <- tibble(skigebietname = c("arosa_lenzerheide",
                                       "engadin_st_moritz",
                                       "engelberg_titlis",
                                       "gstaad_region",
                                       "laax"),
                     skigebiet_nr = c(3,21,27,2,50))


# keine tickets auf ticketcorner

# Aletsch Arena         - 
# Mattherhorn Zermatt   - 





get_ski_price(skigebiet_name = "arosa_lenzerheide",
              skigebiet_nr = 3,
              enddatum = 31)




walk2(dta_ski$skigebietname, dta_ski$skigebiet_nr,
      function(x, y) get_ski_price(skigebiet_name = x,
                                    skigebiet_nr = y, 
                                       enddatum = 16))
