census_api_key(api_key)

#B01001: Population ----
#https://factfinder.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_14_5YR_B01001&prodType=table

B01001_Vars<-c("B01001_001")

B01001 <- get_acs(geography = geo, state = state, variables = B01001_Vars, survey = survey, year = DL_Year, output = "wide")

B01001$Pop<-B01001$B01001_001E

B01001$Pop[B01001$Pop == "NaN"]<-NA

B01001<-B01001 %>% select(GEOID, Pop)

#B02001: Race ----
#https://factfinder.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_16_5YR_B02001&prodType=table
B02001_Vars<-c("B02001_001",
               "B02001_002",
               "B02001_003",
               "B02001_004",
               "B02001_005",
               "B02001_006",
               "B02001_007",
               "B02001_008")

B02001 <- get_acs(geography = geo, state = state, variables = B02001_Vars, survey = survey, year = DL_Year, output = "wide")

B02001$White<-B02001$B02001_002E
B02001$Black<-B02001$B02001_003E
B02001$AIAN<-B02001$B02001_004E
B02001$Asian<-B02001$B02001_005E
B02001$Nonwhite<-(B02001$B02001_001E-B02001$B02001_002E)

B02001$PWhite<-B02001$B02001_002E/B02001$B02001_001E
B02001$PBlack<-B02001$B02001_003E/B02001$B02001_001E
B02001$PAIAN<-B02001$B02001_004E/B02001$B02001_001E
B02001$PAsian<-B02001$B02001_005E/B02001$B02001_001E
B02001$PNonwhite<-(B02001$B02001_001E-B02001$B02001_002E)/B02001$B02001_001E

B02001$PWhite[B02001$PWhite == "NaN"]<-NA
B02001$PBlack[B02001$PBlack == "NaN"]<-NA
B02001$PAIAN[B02001$PAIAN == "NaN"]<-NA
B02001$PAsian[B02001$PAsian == "NaN"]<-NA
B02001$PNonwhite[B02001$PNonwhite == "NaN"]<-NA

B02001<-B02001 %>% select(GEOID, White, Black, AIAN, Asian, Nonwhite, PWhite, PBlack, PAIAN, PAsian, PNonwhite)

#B03001: Ethnicity ----
#https://factfinder.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_16_5YR_B03001&prodType=table
B03001_Vars<-c("B03001_001",
               "B03001_003")

B03001 <- get_acs(geography = geo, state = state, variables = B03001_Vars, survey = survey, year = DL_Year, output = "wide")

B03001$Latino<-B03001$B03001_003E
B03001$PLatino<-B03001$B03001_003E/B03001$B03001_001E

B03001$PLatino[B03001$PLatino == "NaN"]<-NA

B03001<-B03001 %>% select(GEOID, Latino, PLatino)

#B19013: Median Household Income ----
#https://factfinder.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_16_5YR_B19013&prodType=table
B19013_Vars<-c("B19013_001")

B19013 <- get_acs(geography = geo, state = state, variables = B19013_Vars, survey = survey, year = DL_Year, output = "wide")

B19013$MHHI<-B19013$B19013_001E

B19013$MHHI[B19013$MHHI == "NaN"]<-NA

B19013<-B19013 %>% select(GEOID, MHHI)

# Join the data together and clean up intermediate data objects.
acs_data<-left_join(B01001, B02001, by="GEOID")
acs_data<-left_join(acs_data, B03001, by="GEOID")
acs_data<-left_join(acs_data, B19013, by="GEOID")
rm(B01001, B02001, B03001, B19013)