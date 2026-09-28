# Research Question: How are environmental conditions and spatial variation associated with salamander abundance in the Barton Springs ecosystem?
Mini Questions: Temporal: How has salamander abundance changed over the sampling period? Spatial: How does abundance differ among sampling sites? Environmental: Are dissolved oxygen, flow, or water depth associated with observed salamander abundance? Overall: Do these relationships differ between Barton Springs salamanders and Austin blind salamanders?

# Data Cleaning and Validation
The raw dataset contains 50,091 observations across 22 variables and includes environmental, spatial, temporal, and salamander survey measurements.
Initial data validation included standardizing column names, converting sampling dates to a consistent date-time format, inspecting missing and blank values, and verifying variable types.
Exploratory analysis identified one duplicated salamander measurement associated with the same survey event and parameter. The two records were identical across all analyzed fields, including sampling date, site, salamander parameter, observed count, sampling method, project, and survey reference number, but had different `data_ref_no` identifiers. One copy of the duplicated record was removed from the cleaned dataset while preserving the original observation.

# Harmonizing Salamander Abundance Across Reporting Changes
Exploratory analysis identified a change in how Barton Springs salamander size classes were reported over time. Earlier surveys divided salamanders into two size categories:

# - `<1 inch`
# - `>1 inch`

Later surveys divided them into three categories:

# - `<1 inch`
# - `1–2 inches`
# - `>=2 inches`

To determine whether these reporting systems could be combined, survey events containing both systems were compared. For all 2,226 events with complete overlapping measurements, the historical `>1 inch` count exactly equaled the sum of the newer `1–2 inch` and `>=2 inch` counts. No conflicting measurements were observed.
The historical reporting period was also checked for completeness. All 200 survey events before the introduction of the newer size categories contained both `<1 inch` and `>1 inch` measurements.
# Among later surveys, 2,460 events contained all three newer size categories. An additional 162 events contained an incomplete set of newer categories and were investigated individually. Of these, 159 also contained the historical `>1 inch` measurement, allowing total abundance to be calculated using the older reporting system. Three remaining survey events from August 12, 2002 contained valid `<1 inch` observations but no adult-size measurement. These records were retained in the cleaned dataset but are not used when an analysis requires total Barton Springs salamander abundance.
Based on these validation results, Barton Springs salamander abundance can be harmonized at the survey-event level using either:

# **Historical reporting system:**

# `total abundance = <1 inch + >1 inch`

# **Newer reporting system:**

# `total abundance = <1 inch + 1–2 inches + >=2 inches`

The overlap analysis demonstrates that these formulas produce equivalent total abundance measurements when both reporting systems are available.

# **In simpler terms:** the way salamanders were grouped by size changed over the years, so I compared the old and new counting systems before combining them. The overlapping surveys showed that both systems produce the same total salamander count, allowing nearly the entire historical dataset to be analyzed consistently without treating unreported categories as zero.
