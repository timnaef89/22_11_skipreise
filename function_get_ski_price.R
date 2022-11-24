library(httr)
library(xml2)
library(rvest)

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





# keine tickets auf ticketcorner

# Aletsch Arena         - 
# Mattherhorn Zermatt   - 





# define saison ende (aktuell 16. Aprill '23)

enddatum <- as.numeric(difftime(as.Date("2023-04-16"), Sys.Date(),units='days'))




# clear df





get_ski_price <- function(skigebiet_name = "skigebiet_name",
                          skigebiet_nr = skigebiet_nr,
                          enddatum = as.numeric(difftime(as.Date("2023-04-16"), Sys.Date(),units='days'))) {
  
  
  skigebiet <- NULL


for (i in 1:enddatum) {
  
  print(Sys.Date()+i)
  
  url <- paste0("https://ski.ticketcorner.ch/de/venue/",skigebiet_nr,"/products?date=", Sys.Date()+i)
  
  r <- GET(url)
  
  
  rr <- content(r) %>% 
    html_nodes("#ticket-price-collapse-1 .ticket-price-description+ .product .price") %>% 
    html_text() 
  
  
  
  
  
  if(is_empty(rr)) {
    rr <- "Kein Ticket"
  }
  
  if(is.null(skigebiet)) {
    skigebiet <- data.frame(heute = Sys.Date(),
                                tag = Sys.Date()+i,
                                preis = rr)
  }
  else {
    skigebiet <- skigebiet %>% 
      bind_rows(data.frame(heute = Sys.Date(),
                           tag = Sys.Date()+i,
                           preis = rr))
  }
  
 
  
}
  
  
  #maybe safe in global env
  
  #assign(skigebiet_name, skigebiet, envir = .GlobalEnv)
  
write_csv(skigebiet, paste0(skigebiet_name,"_", Sys.Date(),".csv"))

}
