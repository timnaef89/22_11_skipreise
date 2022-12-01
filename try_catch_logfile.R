# Codeschnippsel für Logfile - Errorlog

log_file <- tibble(eintrag = character(),
                      zeit = numeric(),
                       status = character())

write_csv(log_file, "logfile.csv")


tryCatch({get_ski_price(skigebiet_name = "arosa",
                        skigebiet_nr = 3,
                        enddatum = 3)

            write_csv(read_csv("logfile.csv") %>% add_row(eintrag = paste0("Scraping fuer Skigebiet ", "arosa" , " beendet"),
                                                          status = "SUCCESS", 
                                                          zeit = format(Sys.time(), 
                                                                        format = "%Y%m%d%H%M%S")), 
                                                          "logfile.csv")



},
error = function(cond) { cat(paste0("Fehler: ", cond))


  write_csv(read_csv("logfile.csv") %>% add_row(eintrag = cond,
                                                status = "FAILED", 
                                                zeit = format(Sys.time(), 
                                                              format = "%Y%m%d%H%M%S")), 
                                                "logfile.csv")
            
}

)




                                              