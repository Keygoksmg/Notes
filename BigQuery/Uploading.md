# Google BigQuery Setup: Uploading Data via Google Cloud Storage

Preparing to use BigQuery necessitates the uploading of data. There are various methods to [upload data into BigQuery](https://cloud.google.com/bigquery/docs/loading-data). For instance:

- Directly from the BigQuery interface (ideal for smaller datasets)
- From Google Drive

However, the aforementioned approaches may not be viable for large data uploads. A common practice for uploading large datasets involves using Google Cloud Storage (GCS).

Below, I briefly illustrate how to upload a dataset into GCS and prepare it for use with BigQuery.

## 1. Install gcloud CLI on server
To upload data from a server to GCS, the gcloud command line interface (CLI) needs to be installed on the server.

Install the gcloud CLI following the Linux section of [Install the gcloud CLI](https://cloud.google.com/sdk/docs/install#linux).

Note that installing gcloud CLI using apt-get, as described in the Debian/Ubuntu section, may result in a permission error.

Once installed, connect with your project by executing `gcloud init` in your terminal.

## 2. Uploading to Google Cloud Storage (GCS)
The gsutil `cp` command allows you to copy data between your local file system and the cloud, within the cloud, and between different cloud storage providers, like so:

```bash
gsutil cp file_or_folder_path gs://my-bucket
```

Next, file and folder uploading examples are briefly illustrated.

### File upload
To upload ```test.csv``` to the bucket ```gs://test_folder```, use:

```
gsutil cp test.csv gs://test_folder
```

You can also specify the name of the uploaded file as follows:

```
gsutil cp test.csv gs://test_folder/test_uploaded.csv
```

### Folder upload
To upload the folder ```test``` to the bucket ```gs://test_folder ```, use:


```
gsutil -m cp -r dir gs://my-bucket
```

Utilize the ```-r``` option to copy an entire directory tree. For transferring a large number of files, perform a parallel multi-threaded/multi-processing copy using the top-level gsutil ```-m``` option.




## 3. (if you upload compressed file,) unzip the file with Coogle Compute Engine(GCE)
	
When importing ```.gz``` files into BigQuery, be mindful that input files must be non-splittable and should not exceed 4GB. One solution is to unzip using GCE. The simple 4-step solution is illustrated here:

1. Create VM instance on Google Compute Engine

	Create an instance following [this document](https://cloud.google.com/compute/docs/instances/create-start-instance). If you choose the default option (e2-medium, 2vCPU, RAM 4GB) without any changes, the pricing of the instance is $0.03351/hour. Charges apply only when the instance is running.

2. Accont verification

	After creating an instance, log in via SSH, and verify your Google Cloud account by executing ```gcloud init``` in the terminal.


3. Unzip file

	Execute copy, unzip, and upload to GCS using the following commands:	
	```
	gsutil cp gs://input_backet/file_name.csv.gz - | gunzip | gsutil cp - gs://output_backet/file_name.csv
	```
	
	If you want to unzip multiple files in a folder, use the following format:
	
	```
	gsutil cp gs://input_backet/*.gz - | gunzip | gsutil cp - gs://output_backet/output.csv
	```

4. Stop instance

	Ensure to stop the instance after completing the commands. Note: If the instance is not stopped, it will continue accruing costs even when not in use.


Feel free to make further adjustments as per your documentation standards.


