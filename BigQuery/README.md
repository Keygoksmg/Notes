# BigQuery | Introduction to Tips

This is my personal memo for GCP, mainly for BigQuery.

## Instructions
### [Uploading data into BigQuery](Uploading.md)
### [Use BigQuery directly from Notebook](BQ_Notebook.md)
### [Memo in Japanese](README_jp.md)

## Price
Here is the approximate pricing list.
### [Google BigQuery pricing](https://cloud.google.com/bigquery/pricing)
- Queries: $6.25 per TiB (The first 1 TiB per month is free.)
- Storage: $0.02 per GiB per month for active storage

### [Cloud Storage pricing](https://cloud.google.com/storage/pricing)
- Data storage: the amount of data stored in your buckets. Storage rates vary depending on the storage class of your data and location of your buckets.

	> US (United States multi-region) $0.026 per GB per Month for Standard storage

- Data processing: the processing done by Cloud Storage, which includes operations charges, any applicable retrieval fees, and inter-region replication.
- Network usage: the amount of data read from or moved between your buckets.

### [Dataflow pricing](https://cloud.google.com/dataflow/pricing)
Mainly used for decompressing files in Cloud Storage. The pricing is complicated, and the rates depend on the region you use. Here, *us-east1* case is shown as example:

If you use [Dataflow compute resources](https://cloud.google.com/dataflow/pricing#compute-resources).

- Worker CPU and memory (batch, streaming, and FlexRS)
- Dataflow Shuffle data processed (batch only)
- Streaming Engine data processed (streaming only)

	> Batch(\$0.056), FlexRS(\$0.0336), Streaming(\$0.069) per (per vCPU per hour)

If you use [Dataflow Prime compute resources](https://cloud.google.com/dataflow/pricing#prime-compute-resources).

- Data Compute Units (DCUs) (batch and streaming)

	> Batch(\$0.06) and
	> Streaming(\$0.089) per Data Compute Units (per DCU)

## Terms in Google Cloud
###  **User account** and **Service account**
- User account: You! Human account.

	> An account provides users with a name and password for signing in to their Google services.

- Service account:

	> A service account is a special kind of account typically used by an application or compute workload, such as a Compute Engine instance, rather than a person. A service account is identified by its email address, which is unique to the account.
[Service accounts overview](https://cloud.google.com/iam/docs/service-account-overview)


### Project

> A project organizes all your Google Cloud resources. All data in Cloud Storage belongs inside a project. A project consists of a set of users; a set of APIs; and billing, authentication, and monitoring settings for those APIs. 
[What is a project?](https://cloud.google.com/storage/docs/projects#what_is_a_project)


## Useful Basic Commands

- Check your current account and project ```gcloud config list```
- List your projects in your account ```gcloud projects list```

- Create new project ```gcloud projects create PROJECT_ID --name PROJECT_NAME``` 

- Change project ```gcloud config set project PROJECT_ID```


- Create Service account
<small>*service account is related to your project</small>

	```
	gcloud iam service-accounts create SERVICE_ACCOUNT_NAME
	--display-name DISPLAY_SERVICE_ACCOUNT_NAME 
	```
	e.g. 
	
	```
	gcloud iam service-accounts create bq-connector
	--display-name bq-connector-display
	```

- Check the role of PROJECT
	```gcloud projects get-iam-policy PROJECT_ID ```

- Give role to Service account
<small>*e.g.give BigQuery admin role</small>

	```
	gcloud projects add-iam-policy-binding PROJECT_ID \
	--member serviceAccount: SERVICE_ACCOUNT_NAME@ PROJECT_ID.iam.gserviceaccount.com \
	--role roles/bigquery.admin
	```
	e.g. 
	
	```
	gcloud projects add-iam-policy-binding research-megi --member="serviceAccount:bq-connector@research-megi.iam.gserviceaccount.com" --role="roles/bigquery.admin" 
	```

- Generate service account key

	```
	gcloud iam service-accounts keys create FILE_NAME.json --iam-account=SERVICE_ACCOUNT_NAME@PROJECT_ID.iam.gserviceaccount.com
	```
	e.g. 
	
	```
	gcloud iam service-accounts keys create bq-connector-keys.json --iam-account=bq-connector@research-megi.iam.gserviceaccount.com
	```

## Queries to check current usecase in BigQuery
You can run the following queries in your BigQuery.
Also, you can see in [usage.ipynb](usage.ipynb)

- Check storage of one **Dataset**

```
SELECT
SUM(size_bytes)  / 1000000000 AS GBs,
SUM(row_count) AS Records
FROM `Dataset.__TABLES__`
```

- Check the usage of queries by users

```
SELECT
 user_email,
 SUM(total_bytes_processed) AS total_bytes_processed,
 -- Byte to TB
 SUM(total_bytes_processed) / 1024 / 1024 / 1024 /1024 AS total_TB_processed,
 -- TB to Dollar
 SUM(total_bytes_processed) / 1024 / 1024 / 1024 /1024 * 6.0 AS Charges_Dollar,
FROM
`region-asia-northeast1`.INFORMATION_SCHEMA.JOBS_BY_PROJECT
WHERE
 DATE(creation_time) BETWEEN DATE_ADD(CURRENT_DATE('Asia/Tokyo'), INTERVAL -30 DAY ) AND CURRENT_DATE('Asia/Tokyo')
GROUP BY 1
ORDER BY 2 DESC
```
Ref (in Japanese)：[INFORMATION_SCHEMAでBigQueryの利用状況を確認](https://www.niandc.co.jp/sol/tech/date20200923_1893.php)