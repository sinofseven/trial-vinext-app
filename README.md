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
cd terraform/envs/prd
terraform init
terraform apply -auto-approve
```
