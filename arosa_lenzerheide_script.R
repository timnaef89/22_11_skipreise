#### 

library(httr)
library(xml2)
library(tidyverse)
library(rvest)
library(stringr)



# get typ-bezeichnung (ID)

url <- "https://ticket.arosalenzerheide.swiss/products/search?utf8=%E2%9C%93&partner_date=2022-12-02&start_date=2022-12-03&quick-select-button=weekend"




dta <- read_html(url) 



id <- dta %>% 
  html_nodes(".product-row__button , .button__text") %>% 
  html_attr("href") 


id2 <- id[1:46] %>% 
  str_extract("/[0-9]{4,5}") %>% 
  na.omit() %>% 
  str_extract("[0-9]+")

id3 <- id2[c(1:9,16)]

enddatum <- as.numeric(difftime(as.Date("2023-04-16"), Sys.Date(),units='days'))



arosa_df <- NULL

con = dbConnect(SQLite(), "skitickets.sqlite")


for (i in id3[1:length(id3)]) {
  start_time <- Sys.time()
  for (k in 1:enddatum) {
    
    dta <- read_html(paste0("https://ticket.arosalenzerheide.swiss/purchase-path/product-details/",i,"?date=", Sys.Date()+k))
    
    
    typ <- dta %>% 
      html_nodes(".product-details-heading__text") %>% 
      html_text()
    
    
    typ2 <- typ[1] %>% 
      str_extract("(?<=Arosa Lenzerheide ).*")
    
    
    preis <- dta %>% 
      html_nodes(".product-details-configurator__price") %>%
      html_text()
    
    preis2 <- preis %>% 
      str_extract("CHF [0-9]{2,3}.[0-9]{2}")
    
    
    person <- dta %>% 
      html_nodes(".product-details-configurator__label-container .product-details-configurator__label") %>% 
      html_text()
    
    
    first_df <- bind_cols(data.frame(person = person, 
                                 preis = preis2))
    
    second_df <- first_df %>% 
      mutate(ScrapedDate = Sys.Date(),
                                   Gebiet = "arosa_lenzerheide",
                                   Date = Sys.Date() + k,
                                   typ = typ2)
    
    arosa_lenzerheide = "arosa_lenzerheide"
    
    # if(is.null(arosa_df)){
    #   arosa_df <- second_df
    #   
    #   
    # }else{
    #   arosa_df <- rbind(arosa_df, second_df)
    # }
    
    # sql-light
    

    for (j in seq_len(nrow(second_df))) {
      
      sql = paste0("INSERT INTO skiticket_arosa(Gebiet, Date, Typ, Person, Preis)
VALUES ('",arosa_lenzerheide,"', '",Sys.Date()+as.numeric(k),"', '", second_df$typ[j],"', '", second_df$person[j],"', '", second_df$preis[j],"')")
      
      
      print(sql)
      
      dbSendQuery(con, sql)
      
      
    }
    
  }
  
  
  
  
  
  
  
  end_time <- Sys.time()
  print(end_time - start_time)
   
}


dbDisconnect(con)







# hier im loop ergänzen
  



test <- arosa_df %>% 
  group_by(typ, Date) %>% 
  tally()
