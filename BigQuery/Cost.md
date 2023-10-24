# Google BigQuery Cost


Please carefully read [On-demand compute pricing](https://cloud.google.com/bigquery/pricing#on_demand_pricing).

There are important pickup info:

- BigQuery uses a [columnar data structure](https://en.wikipedia.org/wiki/Column-oriented_DBMS)
	- it means ```LIMIT```, ```OFFSET``` do **not** reduce the query cost
	- selecting necessary columns reduce the cost
- Canceling a running query job might incur charges up to the full cost for the query if you let the query run to completion.

- BigQuery provides cost control mechanisms that enable you to cap your query costs. You can set:
	
	- User-level and project-level custom cost controls
	- The maximum bytes billed by a query

	
## Pricing [link](https://cloud.google.com/bigquery/pricing)

### General cost
| Manipulation| Cost | Details     |
| :---        |    :----:   |          --- |
| Storage(Active storage)      | \$0.02/GB/month  | The first 10 GiB is free each month. Active storage includes any table or table partition that has been modified in the last 90 days. |
| Storage(Long-term storage)      | \$0.01/GB/month  | The first 10 GiB is free each month. Long-term storage includes any table or table partition that has not been modified for 90 consecutive days |
| Queries   | \$6.25/TiB/month    | The first 1 TiB per month is free.  You aren't charged for queries that return an error or for queries that retrieve results from the cache.   |


### Free operations [link](https://cloud.google.com/bigquery/pricing#free)
| Manipulation| Details     |
| :---        |       --- |
| Load data   | Free using the shared slot pool. There is no cost loading data from Cloud Storage in the same region. |
| Copy data | Free using the shared slot pool. |
| Export data | Free using the shared slot pool, but you do incur charges for storing the data in Cloud Storage. Customers can choose editions pricing for guaranteed capacity. When you use the EXPORT DATA SQL statement, you are charged for query processing. For details, see Exporting data.|
| Delete operations | You are not charged for deleting datasets or tables, deleting individual table partitions, deleting views, or deleting user-defined functions|
| Metadata operations	 | You are not charged for list, get, patch, update and delete calls. Examples include (but are not limited to): listing datasets, updating a dataset's access control list, updating a table's description, or listing user-defined functions in a dataset.|


## Query Tips

- **Avoid  ```SELECT *```**

	BigQuery stores data by columnar data structure. You can save queries by selecting necessary columns.
	
- **[Use cache effectively](https://cloud.google.com/bigquery/docs/cached-results)**

	When you run a duplicate query, BigQuery attempts to reuse cached results. To retrieve data from the cache, the duplicate query text must be the same as the original query. For query results to persist in a cached results table, the result set must be smaller than the maximum response size. 
	
	
- **[Use Table Sampling instead of ```LIMIT```](https://cloud.google.com/bigquery/docs/table-sampling)**

	Table sampling lets you query random subsets of data from large BigQuery tables. ```LIMIT``` doesn't save your cost.
	
	Unlike the ```LIMIT``` clause, ```TABLESAMPLE``` returns a random subset of data from a table. Also, BigQuery does not cache the results of queries that include a TABLESAMPLE clause, so the query might return different results each time.
	
	For example, the follwoing query selects approx 10%  of a data.

	```
	SELECT * FROM dataset.my_table TABLESAMPLE SYSTEM (10 PERCENT)
	```
	
- **Create Intermediate table**

	Making an intermediate table rather than querying entire dataset  everytime.