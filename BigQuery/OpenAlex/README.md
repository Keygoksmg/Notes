## OpenAlex in BigQuery
OpenAlex raw data comes as JSON data.
Because BigQuery is a column-based query system and treats JSON data as a column, converting JSON into CSV format would save a lot of cost.
For example, when you just need PaperID, querying over JSON data would cost for the entire data, while you will only be charged for the data in the PaperID column once you have the CSV format. 
A stitch in time saves nine!

### Convert JSON to CSV
Here is some SQL that converts JSON to CSV. Since OpenAlex changes data structure pretty often, there might be missing or unmatched data, so feel free to change the details when needed. 

- [works](https://github.com/Keygoksmg/Notes/blob/main/BigQuery/OpenAlex/work.sql)
