# BigQuery tips  
<small>*Google cloudの開発が比較的早いので参考記事など古い可能性あり。(2022/12)</small>

## 基本のチュートリアル/教養
そもそもGoogle Clooud, Big Query, Google Cloud Storage(GCS)とはなんぞや

- Big Query：[公式](https://cloud.google.com/bigquery/pricing?hl=ja),  [参考記事](https://www.dsk-cloud.com/blog/bigquery-pricing-and-points), [BigQuery チュートリアル](https://cloud.google.com/bigquery/docs?hl=ja#training-and-tutorials)

- GCS：[公式](https://cloud.google.com/storage/pricing?hl=ja)、[参考記事](https://www.dsk-cloud.com/solution/gcp/google-cloud-storage), [GCS チュートリアル](https://cloud.google.com/storage/docs?hl=ja#training-and-tutorials)


BigQueryを扱う時に知っておくべきコストに関する教養

- [BigQueryのコストに対する恐怖心を払拭する](https://qiita.com/kamujun/items/ab3cd3e6f8934a01cbc8)

- [BigQueryのお金のあれこれ](https://zenn.dev/k_matsumoto/articles/533fe48e13e2ac)


Big Queryのdataset作成時のリージョンについて  
<small>*参考記事が古い可能性あり。</small>

- [Google BigQuery はロケーションをまたいだクエリが書けない](https://note.com/miya_y/n/nc18b0a6e1063)

* * * *


# Big Query and pandas
参考：[BigQuery ↔ Pandas間で読み込み/書き込み](https://qiita.com/komiya_____/items/8fd900006bbb2ebeb8b8)
## 設定の流れ
大まかな下準備流れは以下の通りである。
	
1. ユーザーアカウント, Projectを作成し、設定する。
2. サービスアカウントを作る。

	```
	gcloud iam service-accounts create サービスアカウント名 \
	--display-name サービスアカウントディスプレイ名 
	```
3. サービスアカウントに権限(role)を与える。（今回ならBig Queryの権限）

	```
	gcloud projects add-iam-policy-binding プロジェクトID \
	--member serviceAccount:サービスアカウントネーム@プロジェクトID.iam.gserviceaccount.com \
	--role roles/bigquery.admin
	```
4. サービスアカウントのkeyを作成する。

	```
	gcloud iam service-accounts keys create FILE_NAME.json --iam-account=SERVICE_ACCOUNT_NAME@PROJECT_ID.iam.gserviceaccount.com
	```
5. 4で作成したkeyのpathを環境変数に書き込む

	`GOOGLE_APPLICATION_CREDENTIALS="KEY_PATH"`
6. pip/condaで必要なモジュールをinstall  
	`pip install --upgrade pandas-gbq 'google-cloud-bigquery[bqstorage,pandas]'`

8. Run query.

## 実行
- [example_bq_pandas.ipynb](example_bq_pandas.ipynb)
- [現在使ってる使用状況を把握](usage.ipynb)




## Google Cloud上の用語・概念
###  User account　と　Service account
- User accountはgmailなど、人間に該当する。
- Service account:

> サービス アカウントは、ユーザーではなく、Compute Engine 仮想マシン（VM）インスタンスなどのアプリケーションやコンピューティング ワークロードで使用される特別なアカウントです。アプリケーションはサービス アカウントを使用して、承認された API 呼び出しを行います。
[参考](https://cloud.google.com/iam/docs/service-accounts?hl=ja)



###  プロジェクトとは
プロジェクト単位で課金やユーザー管理を行う。
[参考](https://qiita.com/miyuki_samitani/items/0cdd1b8b0f4feb0506f8)


### 認証
サービスアカウントをもとにBigQueryなどのサービスをAPIを通じて使えるように認証の手続きをする。
[認証の手順](https://cloud.google.com/docs/authentication/getting-started#create-service-account-gcloud)


##  使用するコマンド・便利なコマンド

- ログインしているアカウント/プロジェクトを確認  
```gcloud config list```

- プロジェクト一覧の確認  
```gcloud projects list```

- プロジェクトの作成  
```gcloud projects create プロジェクトID --name プロジェクト名```

- プロジェクトの切り替え  
```gcloud config set project プロジェクトID```


- サービスアカウントの作成  
<small>*プロジェクトを適切に変更してからそのプロジェクトでサービスアカウントを作る。</small>

	```
	gcloud iam service-accounts create サービスアカウント名
	--display-name サービスアカウントディスプレイ名 
	```
	e.g. ``` gcloud iam service-accounts create bq-connector
	--display-name bq-connector-display ```

- プロジェクトに紐付いている権限を確認  
```gcloud projects get-iam-policy プロジェクトID```

- サービスアカウントへ権限付与
<small>*BigQuery管理者の権限を付与する</small>

	```
	gcloud projects add-iam-policy-binding プロジェクトID \
	--member serviceAccount:サービスアカウントネーム@プロジェクトID.iam.gserviceaccount.com \
	--role roles/bigquery.admin
	```
	e.g. 
	
	```
	gcloud projects add-iam-policy-binding research-megi --member="serviceAccount:bq-connector@research-megi.iam.gserviceaccount.com" --role="roles/bigquery.admin" 
	```

- サービスアカウントキー作成

	```
	gcloud iam service-accounts keys create FILE_NAME.json --iam-account=SERVICE_ACCOUNT_NAME@PROJECT_ID.iam.gserviceaccount.com
	```
	e.g. 
	
	```
	gcloud iam service-accounts keys create bq-connector-keys.json --iam-account=bq-connector@research-megi.iam.gserviceaccount.com
	```

##  pandas経由扱う際のtips  
<small>*参考記事が古い可能性あり。</small>

- [遅すぎる `pandas.read_gbq` を使わずに、Google BigQueryから高速にデータを読み込む](https://shunyaueta.com/posts/2019-10-03/)

- [BigQueryStorageAPIを使ってBigQueryからPandas DataFrameに高速変換](https://zenn.dev/r2en/articles/b804085227983c)

- サービスアカウントのkeyを環境変数として設定するが、複数のプロジェクトを扱う際は環境変数の切り替えが必要になる。そこでdirenvを使ってディレクトリ単位で行う。　[direnvを使おう](https://qiita.com/kompiro/items/5fc46089247a56243a62)
* * * *

# 費用に関するクエリ

参考：[INFORMATION_SCHEMAでBigQueryの利用状況を確認](https://www.niandc.co.jp/sol/tech/date20200923_1893.php)

- ある**Dataset**の容量を調べる

```
SELECT
SUM(size_bytes)  / 1000000000 AS GBs,
SUM(row_count) AS Records
FROM `Dataset.__TABLES__`
```

- ユーザ毎のクエリ処理量の確認

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

* * * *

# Tips
## Upload txt file to BigQuery
Local > upload to GCS > Create bq table from: Google Cloud Storage > File Format: CSV > Table type: External tableの順でいけるみたい.  
[Loading text file into BigQuery](https://maczulajtys.com/posts/load-text-file-to-bigquery/)

