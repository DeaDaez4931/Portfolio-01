# ============================================
# Barton Springs Salamander Analysis
# Exploratory Data Analysis
# ============================================

# Run data cleaning script and load clean_data
source("src/01_clean_data.R")

# ============================================
# Inspect dataset categories
# ============================================

table(clean_data$parameter_type)

table(clean_data$site_name)

table(clean_data$medium)

table(clean_data$unit)

# ============================================
# Inspect salamander parameters
# ============================================

salamander_data <- clean_data[
  clean_data$parameter_type == "Salamanders",
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

names(comparison_wide) <- c(
  "sample_ref_no",
  "two_plus",
  "one_to_two",
  "adult_over_one"
)

names(comparison_wide)

comparison_wide$new_over_one <- 
  comparison_wide$one_to_two + comparison_wide$two_plus

comparison_wide$matches <- 
  comparison_wide$adult_over_one == comparison_wide$new_over_one

table(comparison_wide$matches, useNA = "ifany")

# ============================================
# Check <1 inch category consistency over time
# ============================================

under_one <- barton_salamanders[
  barton_salamanders$parameter ==
    "BARTON SPRINGS SLMNDR  (TOTAL <1IN.)",
]

# Check which methods were used
table(under_one$method)

# Check which projects recorded this measurement
table(under_one$project)

# Check date range for each method
aggregate(
  sample_date ~ method,
  data = under_one,
  FUN = range
)

# Check date range for each project
aggregate(
  sample_date ~ project,
  data = under_one,
  FUN = range
)

# ============================================
# Display <1 inch method/project date ranges
# ============================================

method_dates <- aggregate(
  sample_date ~ method,
  data = under_one,
  FUN = function(x) c(
    first = format(min(x), "%Y-%m-%d"),
    last = format(max(x), "%Y-%m-%d")
  )
)

project_dates <- aggregate(
  sample_date ~ project,
  data = under_one,
  FUN = function(x) c(
    first = format(min(x), "%Y-%m-%d"),
    last = format(max(x), "%Y-%m-%d")
  )
)

method_dates
project_dates

# ============================================
# Check for multiple <1 inch measurements
# within the same survey event
# ============================================

under_one_per_event <- table(
  under_one$sample_ref_no
)

table(under_one_per_event)

max(under_one_per_event)

# ============================================
# Inspect survey events with duplicate <1 inch measurements
# ============================================

duplicate_under_one_events <- names(
  under_one_per_event[under_one_per_event > 1]
)

duplicate_under_one_events

under_one[
  under_one$sample_ref_no %in% duplicate_under_one_events,
]

# ============================================
# Check for duplicate salamander measurements
# within survey events
# ============================================

salamander_measurements_per_event <- table(
  salamander_data$sample_ref_no,
  salamander_data$parameter
)

# Check the largest number of repeated measurements
max(salamander_measurements_per_event)

# Count how many survey event/parameter combinations
# occur more than once
sum(salamander_measurements_per_event > 1)

# ============================================
# Compare duplicate record fields
# ============================================

duplicate_records <- under_one[
  under_one$sample_ref_no %in% duplicate_under_one_events,
]

duplicate_records

# Check which columns differ between duplicate records
sapply(
  duplicate_records,
  function(x) length(unique(x))
)

# ============================================
# Check completeness of newer size categories
# ============================================

new_size_parameters <- c(
  "BARTON SPRINGS SLMNDR  (TOTAL <1IN.)",
  "BARTON SPRINGS SLMNDR (TOTAL 1-2IN.)",
  "BARTON SPRINGS SLMNDR (TOTAL >=2IN.)"
)

new_size_data <- barton_salamanders[
  barton_salamanders$parameter %in% new_size_parameters &
  barton_salamanders$sample_date >= as.POSIXct("2002-01-30"),
]

new_size_per_event <- table(
  new_size_data$sample_ref_no,
  new_size_data$parameter
)

table(
  rowSums(new_size_per_event > 0)
)

# ============================================
# Inspect incomplete newer size-category events
# ============================================

incomplete_event_ids <- rownames(
  new_size_per_event[
    rowSums(new_size_per_event > 0) < 3,
  ]
)

incomplete_size_data <- new_size_data[
  new_size_data$sample_ref_no %in% incomplete_event_ids,
]

table(incomplete_size_data$parameter)

# ============================================
# Inspect incomplete size-category events
# ============================================

# Check date range
range(incomplete_size_data$sample_date)

# Check sampling sites
table(incomplete_size_data$site_name)

# Check methods
table(incomplete_size_data$method)

# Check projects
table(incomplete_size_data$project)

# ============================================
# Check whether incomplete newer events
# contain the historical >1 inch measurement
# ============================================

old_adult_parameter <-
  "BARTON SPGS SALMNDR  (ADULT) > 1 INCH"

old_adult_in_incomplete_events <- barton_salamanders[
  barton_salamanders$sample_ref_no %in% incomplete_event_ids &
  barton_salamanders$parameter == old_adult_parameter,
]

length(unique(
  old_adult_in_incomplete_events$sample_ref_no
))

# ============================================
# Inspect incomplete events without old adult measurement
# ============================================

events_with_old_adult <- unique(
  old_adult_in_incomplete_events$sample_ref_no
)

unresolved_event_ids <- setdiff(
  incomplete_event_ids,
  events_with_old_adult
)

unresolved_event_ids

barton_salamanders[
  barton_salamanders$sample_ref_no %in% unresolved_event_ids,
]
# ============================================
# Check completeness of historical size categories
# ============================================

old_size_parameters <- c(
  "BARTON SPRINGS SLMNDR  (TOTAL <1IN.)",
  "BARTON SPGS SALMNDR  (ADULT) > 1 INCH"
)

old_size_data <- barton_salamanders[
  barton_salamanders$sample_date < as.POSIXct("2002-01-30") &
  barton_salamanders$parameter %in% old_size_parameters,
]

old_size_per_event <- table(
  old_size_data$sample_ref_no,
  old_size_data$parameter
)

table(
  rowSums(old_size_per_event > 0)
)