library(readr)
library(dplyr)
library(stringr)

process_spreadsheet <- function(file_path) {
  # Step 1: Read the CSV file into a data frame
  df <- read_csv(file_path, col_names = TRUE, col_types = cols(.default = "c")) 
  
  # Step 2: Remove the second row
  df <- df[-1, ]
  
  # Step 3: Ensure column names are correct and unique
  colnames(df) <- make.names(colnames(df), unique = TRUE)
  
  # Step 4: Remove the '1500000US' prefix from the GEO_ID field and keep as text
  df <- df %>%
    mutate(GEO_ID_Corrected = as.character(str_remove(GEO_ID, "^1500000US"))) %>% 
    select(GEO_ID_Corrected, everything()) # Reorder columns to have 'GEO_ID_Corrected' as the first column
  
  # Step 5: Write the processed data frame back to a new CSV file
  output_file <- paste0(dirname(file_path), "/processed_", basename(file_path))
  write_csv(df, output_file)
  
  # Step 6: Return the processed data frame
  return(df)
}

# update with your file path:
file_path <- "C:/Users/ureka/OneDrive/Desktop/ABQ/New folder/demo_census/ACSDT5Y2022.B16004_2024-09-26T125834/ACSDT5Y2022.B16004-Data.csv"

# Process the spreadsheet
processed_data <- process_spreadsheet(file_path)

# Print the processed data frame to the console
print(processed_data)
