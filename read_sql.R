################################################################################
library(DBI)
library(RSQLite)


# get connection

con = dbConnect(SQLite(), "skitickets.sqlite")

# get df_skigebiet

test_skigebiet_arosa <- dbReadTable(con, "skiticket_arosa")

# remove befehl
#dbRemoveTable(con, "skiticket_arosa")

# disconnect to sql-server

dbDisconnect(con)
