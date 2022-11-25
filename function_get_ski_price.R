library(httr)
library(xml2)
library(rvest)
library(lubridate)
library(DBI)
library(RSQLite)

# Quelle

#quelle <- "https://ski.ticketcorner.ch/de/"


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
  
  
  


for (i in 1:enddatum) {
  
  print(Sys.Date()+i)
  
  url <- paste0("https://ski.ticketcorner.ch/de/venue/",skigebiet_nr,"/products?date=", Sys.Date()+i)
  
  r <- GET(url)
  
  
  rr <- content(r) 
  
  rrr <- rr %>% 
    html_nodes(".tickets-price .px-0 div:nth-child(1) > div:nth-child(1) > :nth-child(1)") %>% 
    html_text()
  
  
  
  rrr = rrr[!(rrr == "Gratis Kind")]
  
  df_ski = data.frame(typ = rep(NA, 1000), 
                        person = rep(NA, 1000),
                        preis = rep(NA, 1000))
  
  row = 1
  for(k in seq_along(rrr)){
    if(grepl("ticket", rrr[k])){
      typ = rrr[k]
    }else{
      if(!grepl("[0-9]", rrr[k])){
        person = rrr[k]
      }else{
        df_ski[row,"typ"] = typ
        df_ski[row, "person"] = person
        df_ski[row, "preis"] = rrr[k]
        row = row + 1 
      }
    }
  }
  
  
  df_ski = df_ski %>% 
    na.omit() %>% 
    mutate(skigebiet = skigebiet_name,
           tag = Sys.Date()+i)

  
  # print(df_ski)
  

  con = dbConnect(SQLite(), "skitickets.sqlite")

  
  # in die Tabelle schreiben
  
  
  for (k in seq_len(nrow(df_ski))) {
    
    sql = paste0("INSERT INTO skiticket(Gebiet, Date, Typ, Person, Preis)
VALUES ('",skigebiet_name,"', '",Sys.Date()+i,"', '", df_ski$typ[k],"', '", df_ski$person[k],"', '", df_ski$preis[k],"')")
    dbSendQuery(con, sql)
    
    
  }
    
  # dbReadTable(con, "skiticket")
  
  
  #dbSendQuery(con, "DELETE FROM skiticket")
  
  dbDisconnect(con)
 
  
}
  
  


}
