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
# Inspect dataset categories
# ============================================

table(raw_data$parameter_type)

table(raw_data$site_name)

table(raw_data$medium)

table(raw_data$unit)

# ============================================
# Inspect salamander parameters
# ============================================

salamander_data <- raw_data[
  raw_data$parameter_type == "Salamanders",
]

sort(
  table(salamander_data$parameter),
  decreasing = TRUE
)

# ============================================
# Inspect Barton Springs salamander methods
# ============================================

barton_salamanders <- salamander_data[
  grepl("BARTON", salamander_data$parameter),
]

table(
  barton_salamanders$parameter,
  barton_salamanders$method
)

table(
  barton_salamanders$project
)

range(barton_salamanders$sample_date)

# ============================================
# Check when major salamander measures were used
# ============================================

major_parameters <- c(
  "BARTON SPGS SALMNDR  (ADULT) > 1 INCH",
  "BARTON SPRINGS SLMNDR  (TOTAL <1IN.)",
  "BARTON SPRINGS SLMNDR (TOTAL 1-2IN.)",
  "BARTON SPRINGS SLMNDR (TOTAL >=2IN.)"
)

major_barton <- barton_salamanders[
  barton_salamanders$parameter %in% major_parameters,
]

# ============================================
# Check date ranges of major salamander measures
# ============================================

date_ranges <- aggregate(
  sample_date ~ parameter,
  data = major_barton,
  FUN = range
)

date_ranges$first_date <- as.POSIXct(
  date_ranges$sample_date[, 1],
  origin = "1970-01-01"
)

date_ranges$last_date <- as.POSIXct(
  date_ranges$sample_date[, 2],
  origin = "1970-01-01"
)

date_ranges[
  ,
  c("parameter", "first_date", "last_date")
]

# ============================================
# Check overlap between old and new size categories
# ============================================

overlap_data <- major_barton[
  major_barton$sample_date >= as.POSIXct("2002-01-30") &
  major_barton$sample_date <= as.POSIXct("2015-10-22"),
]

table(overlap_data$parameter)

# ============================================
# Check whether sample_ref_no identifies a survey event
# ============================================

event_check <- aggregate(
  cbind(
    site_count = sample_site_no,
    date_count = as.numeric(sample_date)
  ) ~ sample_ref_no,
  data = overlap_data,
  FUN = function(x) length(unique(x))
)

table(event_check$site_count)
table(event_check$date_count)

# ============================================
# Count measurements within each survey event
# ============================================

measurements_per_event <- table(
  overlap_data$sample_ref_no,
  overlap_data$parameter
)

head(measurements_per_event)

table(
  rowSums(measurements_per_event > 0)
)

# ============================================
# Compare old and new adult size categories
# ============================================

comparison_data <- overlap_data[
  overlap_data$parameter %in% c(
    "BARTON SPGS SALMNDR  (ADULT) > 1 INCH",
    "BARTON SPRINGS SLMNDR (TOTAL 1-2IN.)",
    "BARTON SPRINGS SLMNDR (TOTAL >=2IN.)"
  ),
  c("sample_ref_no", "parameter", "result")
]

comparison_wide <- reshape(
  comparison_data,
  idvar = "sample_ref_no",
  timevar = "parameter",
  direction = "wide"
)

names(comparison_wide)