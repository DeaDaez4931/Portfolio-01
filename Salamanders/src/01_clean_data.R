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

# Confirm expected number of columns
stopifnot(ncol(raw_data) == 22)

# ============================================
# Standardize column names
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

# ============================================
# Convert sample date to date-time
# ============================================

raw_data$sample_date <- as.POSIXct(
  raw_data$sample_date,
  format = "%m/%d/%Y %I:%M:%S %p"
)

# Check conversion
head(raw_data$sample_date)
class(raw_data$sample_date)
sum(is.na(raw_data$sample_date))

# ============================================
# Check blank values in character columns
# ============================================

character_columns <- sapply(raw_data, is.character)

colSums(
  raw_data[character_columns] == "",
  na.rm = TRUE
)

# ============================================
# Inspect values in columns containing blanks
# ============================================

unique(raw_data$qualifier)
unique(raw_data$qc_flag)
unique(raw_data$qc_type)

# Check sample IDs that are blank
head(
  raw_data[raw_data$sample_id == "", ],
  10
)

# ============================================
# Validate cleaning steps
# ============================================

# Confirm all dates converted successfully
stopifnot(sum(is.na(raw_data$sample_date)) == 0)

# Confirm result is numeric
stopifnot(is.numeric(raw_data$result))

# ============================================
# Create working clean dataset
# ============================================

clean_data <- raw_data