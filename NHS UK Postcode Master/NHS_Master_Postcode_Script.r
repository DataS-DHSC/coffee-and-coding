# Extract Postcode Information from NHSPD dataset (on GOV UK)
# Download location Office for National Statistics data - NHS Digital
# https://digital.nhs.uk/services/organisation-data-service/data-downloads/office-for-national-statistics-data
# V1.0 - 140521 - Sarah Eaglesfield (sarah.eaglesfield@dhsc.gov.uk / sarah.eaglesfield@test-and-trace.nhs.uk)


#   ****     INSTRUCTIONS  ****
#There are 41 columns of data in the dataset. These are detailed on P27-P40 the User Guide PDF. 
#To Add An Additional Column 
#1. Download the corresponding lookup table from the above URL
#2. Change the col_type from col_skip to its actual type given in comments on the sam line
#3. Add the file location to the fnames list

#   ****     TROUBLESHOOTING  ****
#1. Make Sure The Path of the Filename is Set Correctly Relative to the Base Directory for R
#2. Some NHS Lookup Tables have 3 columns - drop the unneeded column on an adhoc basis


#   ****     MASTER COLUMN LIST - LOAD COLUMS THAT WILL BE EXPORTED AND SKIP OTHERS ****

col_types = {cols(
  "PCD2"       = col_character(),
  "PCDS"       = col_skip(), #col_character()
  "DOINTR"     = col_skip(), #col_double()
  "DOTERM"     = col_double(),
  "OSEAST100M" = col_skip(), #col_double()
  "OSNRTH100M" = col_skip(), #col_double()
  "OSCTY"      = col_character(),
  "ODSLAUA"    = col_skip(), #col_character()
  "OSLAUA"     = col_character(),
  "OSWARD"     = col_character(),
  "USERTYPE"   = col_skip(), #col_double()
  "OSGRDIND"   = col_skip(), #col_double()
  "CTRY"       = col_character(),
  "OSHLTHAU"   = col_skip(), #col_character()
  "RGN"        = col_skip(), #col_character()
  "OLDHA"      = col_skip(), #col_character()
  "NHSER"      = col_character(),
  "CCG"        = col_character(),
  "PSED"       = col_skip(), #col_character()
  "CENED"      = col_skip(), #col_character()
  "EDIND"      = col_skip(), #col_character()
  "WARD98"     = col_skip(), #col_character()
  "OA01"       = col_skip(), #col_character()
  "NHSRLO"     = col_skip(), #col_character()
  "HRO"        = col_skip(), #col_character()
  "LSOA01"     = col_skip(), #col_character()
  "UR01IND"    = col_skip(), #col_character()
  "MS0A01"     = col_skip(), #col_character()
  "CANNET"     = col_skip(), #col_character()
  "SCN"        = col_character(),
  "OSHAPREV"   = col_skip(), #col_character()
  "OLDPCT"     = col_skip(), #col_character()
  "OLDHRO"     = col_skip(), #col_character()
  "PCON"       = col_skip(), #col_character()
  "CANREG"     = col_skip(), #col_character()
  "PCT"        = col_skip(), #col_character()
  "OSEAST1M"   = col_skip(), #col_double()
  "OSNRTH1M"   = col_skip(), #col_double()
  "OA11"       = col_skip(), #col_character()
  "LSOA11"     = col_skip(), #col_character()
  "MSOA11"     = col_character(),
  "CALNCV"     = col_skip(), #col_character()
  "STP"        = col_skip() #col_character()
)}


#Start The Timer
tictoc::tic()

#Read The Postcode Data from the GRIDALL CSV in the Data Folder
postcodes <- read_csv("Data/gridall.csv",
                      col_names = names(col_types$cols),
                      col_types = col_types) 

#Drop Postcodes That Have Expired then Drop the Column As It Is No Longer Needed
postcodes[is.na(postcodes$DOTERM), ]
postcodes$DOTERM <- NULL


#List of lookup table CSVs for each element used in final Csv
fnames <- c("Documents/Names and Codes/County names and codes EN as at 04_20.csv", #OSCTY
            "Documents/Names and Codes/LA_UA names and codes UK as at 04_21.csv", #OOSLAUA
            "Documents/Names and Codes/Ward names and codes UK as at 12_19.csv", #OSWARD
            "Documents/Names and Codes/Country names and codes UK as at 08_12.csv", #CTRY
            "Documents/Names and Codes/NHSER names and codes EN as at 04_19.csv", #NHSER
            "Documents/Names and Codes/CCG names and codes EN as at 04_20.csv", #CCG
            "Documents/Names and Codes/SCN names and codes EN as at 04_13.csv", #SCN
            "Documents/Names and Codes/MSOA (2011) names and codes UK as at 12_12.csv") #MSOA11 



#Columnames from Postcodes
cnames <- colnames(postcodes)
#A list of all Dataframes
dframes <- paste("df",1:length(fnames),sep="") 
dframes <- lapply(strsplit(as.character(dframes),split=','),trimws)

#Columns B and J contain the matches
match_columns <- c("b", "j")

#Loop over each filename in the list
for(i in 1:length(fnames)) {
  p=i+1
  q=p-1
  #Load lookup data
  lookup <- read_csv(fnames[i])
  #Push a column name to merge
  names(lookup) <- c(cnames[p])
  #Merge Postcodes with the Lookup Table
    d <- merge(postcodes, lookup,  by.x = cnames[p], by.y =cnames[p], all = TRUE,  suffixes = c("by"))
    colnames(d) <- letters[1:length(d)]
    d <- d[match_columns]
    #Create a dataframe for each file name (later delted)
  assign(paste("df", i, sep = ""), d)

  
  
}

#Need to change this to a loop
final <- df1 %>% inner_join(df2, by = "b") %>% inner_join(df3, by = "b")  %>% inner_join(df4, by = "b") %>% inner_join(df5, by = "b")  %>% inner_join(df6, by = "b")  %>% inner_join(df7, by = "b") %>% inner_join(df8, by = "b") 

#Friendly Column Names
names(final) <-  c("Postcode","County", "Local Authority District", "Ward", "Country", "NHS England Region", "Clinical Commissioning Group", "Strategic Clinical Network", "MSOA")

#Write Final File
write_csv(final, "Output/NHS_UK_Postcodes_Master.csv")
tictoc::toc()

#Clean Up Memory - Comment Out To See Underlying Datasets
rm(list=setdiff(ls(), "final"))