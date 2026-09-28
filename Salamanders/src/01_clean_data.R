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

# ============================================
# Clean column names
# ============================================

names(raw_data) <- c(
  "watershed",
  "sample_date",
  "site_name",
  "longitude",
  "latitude",
  "site_type",
  "medium",
  "parameter_type",
  "parameter",
  "qualifier",
  "result",
  "unit",
  "filter",
  "sample_id",
  "sample_site_no",
  "method",
  "qc_flag",
  "project",
  "data_ref_no",
  "sample_ref_no",
  "time_null",
  "qc_type"
)

names(raw_data)