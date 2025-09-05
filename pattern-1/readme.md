# Real word use case of the pattern
 This is useful for monthly reports, adhoc data slicing

# How to identify the pattern in any situation
- Variables present in a single table with no need to join with other tables
- Presence of a specific condition. e.g a big area is defined as where the population is more than 5000. Find all big areas
- pro-tip: there are some helper functions that can helping with selecting rows with the conditions. e.g. `LENGTH`, `DATEDIFF` that can be leverage to make search condition easier