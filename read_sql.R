################################################################################
library(DBI)
library(RSQLite)


# get connection

con = dbConnect(SQLite(), "skitickets.sqlite")

# get df_skigebiet

test_skigebiet_25_11qwer <- dbReadTable(con, "skiticket")

# disconnect to sql-server

dbDisconnect(con)
