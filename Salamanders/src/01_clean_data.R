# ============================================
# Barton Springs Salamander Analysis
# Data Cleaning
# ============================================

print(getwd())

# Load raw data
raw_data <- read.csv(
  "data/raw/Barton_Springs_Salamanders_raw.csv"
)

# Look at the dataset
head(raw_data)

# Check dimensions
dim(raw_data)

# Look at column names
names(raw_data)

# Look at data types
str(raw_data)

# Check missing values
colSums(is.na(raw_data))