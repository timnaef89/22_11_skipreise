library(DBI)
library(RSQLite)


                        #####################
                        ### !!!WICHTIG!!! ###
                        #### NUR EINMAL ##### 
                        #### AUSFÜHREN ######
                        #####################

# connect to sql-server

#con = dbConnect(SQLite(), "skitickets.sqlite")



# create df_skiticket

# sql = "CREATE TABLE skiticket(
#   ScrapedDate DATE DEFAULT (STRFTIME('%Y-%m-%d', 'NOW', 'localtime')),
#   Gebiet VARCHAR(32) NOT NULL,
#   Date DATE NOT NULL,
#   Typ VARCHAR(256) NOT NULL,
#   Person VARCHAR(64) NOT NULL,
#   Preis VARCHAR(64)
# )"



# send query

# dbSendQuery(con, sql)
