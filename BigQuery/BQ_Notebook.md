# Big Query and pandas
References:

- [Visualize BigQuery data in Jupyter notebooks](https://cloud.google.com/bigquery/docs/visualize-jupyter)

- [Accessing Google Big Query from Jupyter notebook. (Medium)](https://rspraneethkumar.medium.com/accessing-google-big-query-from-jupyter-notebook-878145ce37dc)

## Objective
Connect and use BigQuery from your notebook like [example_bq_pandas.ipynb](example_bq_pandas.ipynb)


## Procedure
1. You need to enable the API on your GCP project. Follow [Before you begin](https://cloud.google.com/bigquery/docs/visualize-jupyter#before-you-begin). If you don't have project, create it.

2. Create **service account**

	```
	gcloud iam service-accounts create SERVICE_ACCOUNT_NAME \
	--display-name SERVICE_ACCOUNT_DISPLAY_NAME
	```
	edit ```SERVICE_ACCOUNT_NAME``` and ```DISPLAY_SERVICE_ACCOUNT_NAME ``` as your preference.
	
3. Set role to your created **service account**

	This time, we give bigquery.admin role to the service account.
	
	```
	gcloud projects add-iam-policy-binding PROJECT_ID \
	--member serviceAccount: SERVICE_ACCOUNT_NAME@ PROJECT_ID.iam.gserviceaccount.com \
	--role roles/bigquery.admin
	```
	Edit ```SERVICE_ACCOUNT_NAME ``` and ```PROJECT_ID ``` as yours.

	*Now, you can see the created service account details on [IAM page on the project](https://console.cloud.google.com/iam-admin/iam). You can also set those service account on web site.


4. Create **service account key**

	```
	gcloud iam service-accounts keys create \
	service_account_keys.json \
	--iam-account=SERVICE_ACCOUNT_NAME@PROJECT_ID.iam.gserviceaccount.com
	```
	Once you run this command, you will see the json file "service_account_keys.json". You can change this file name.
	
	
5. Set key_path in your env file.

	`GOOGLE_APPLICATION_CREDENTIALS="KEY_PATH"`

6. Install necessary packages
	`pip install --upgrade pandas-gbq 'google-cloud-bigquery[bqstorage,pandas]'`
	
7. Run query. [example_bq_pandas.ipynb](example_bq_pandas.ipynb)



## Terms in Google Cloud
###  **User account** and **Service account**
- User account: You!

> An account provides users with a name and password for signing in to their Google services.

- Service account:

> A service account is a special kind of account typically used by an application or compute workload, such as a Compute Engine instance, rather than a person. A service account is identified by its email address, which is unique to the account.
[Service accounts overview](https://cloud.google.com/iam/docs/service-account-overview)


### Project

> A project organizes all your Google Cloud resources. All data in Cloud Storage belongs inside a project. A project consists of a set of users; a set of APIs; and billing, authentication, and monitoring settings for those APIs. 
[What is a project?](https://cloud.google.com/storage/docs/projects#what_is_a_project)


##  Commands

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
	e.g. ``` gcloud iam service-accounts create bq-connector
	--display-name bq-connector-display ```

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

# Queries to check current usecase in BigQuery
You can run the following queries in your BigQuery.

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
Ref in JP：[INFORMATION_SCHEMAでBigQueryの利用状況を確認](https://www.niandc.co.jp/sol/tech/date20200923_1893.php)
