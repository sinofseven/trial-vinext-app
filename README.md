# trial-vinext-app

Vinextで作成したNext.jsのアプリをAWS Lambdaにデプロイするサンプル。

CloudfrontとLambda URL Functionsで動かすのでAWSリソースのIaCにはTerraformを使用している。

## How to Deploy

### 1. Dependency Install

```bash
npm ci
```

### 2. Build

```bash
npm run build
```

### 3. Deploy

環境変数などを使ってAWS CLIでAWSに触れるようにしてから動かしてください。

```bash
$ cd terraform/envs/prd
$ terraform init
$ terraform apply -auto-approve

Apply complete!

Outputs:

cloudfront_url = "00000000000000.cloudfront.net"
public_bucket_name = "trial-vinext-app-000000000000-ap-northeast-1-an"

# outputで出力されたS3 Bucket名を使って静的ファイルをS3 Bucketにアップロードしてください
$ cd .output/public
$ aws s3 sync . s3://trial-vinext-app-000000000000-ap-northeast-1-an
```
