# terraform-env-workshop

## install

```bash
brew install awscli
brew install kubernetes-cli
brew install terraform
```

## variable

```bash
# for eks
export CLUSTER_NAME="eks-demo"
export CLUSTER_ROLE="devops"

# for ingress
export ROOT_DOMAIN="spic.me" # nalbam.com
export BASE_DOMAIN="demo.spic.me" # demo.nalbam.com

# for keycloak, jenkins, grafana, argo-cd
export ADMIN_USERNAME="me@nalbam.com"
export ADMIN_PASSWORD="********"

# for keycloak
# https://console.cloud.google.com/ : API 및 인증정보 > 사용자 인증 정보 > OAuth 2.0 클라이언트 ID
# 승인된 리디렉션 URI : https://keycloak.${BASE_DOMAIN}/auth/realms/demo/broker/google/endpoint
export GOOGLE_CLIENT_ID="********-********.apps.googleusercontent.com"
export GOOGLE_CLIENT_SECRET="********"

# for keycloak
# https://github.com/settings/developers : OAuth Apps
export GITHUB_CLIENT_ID="********"
export GITHUB_CLIENT_SECRET="********"

# for jenkins, alertmanager to #sandbox
export SLACK_TOKEN="********/********/********"

# https://app.datadoghq.com/account/settings#api
export DATADOG_API_KEY="********"
export DATADOG_APP_KEY="********"

# for logzio
export LOGZIO_TOKEN="********"
```

## aws ssm

```bash
export SSM_KEY="/k8s/${CLUSTER_ROLE}/${CLUSTER_NAME}"

aws ssm put-parameter --name ${SSM_KEY}/admin_username --value "${ADMIN_USERNAME}" --type SecureString --overwrite | jq .
aws ssm put-parameter --name ${SSM_KEY}/admin_password --value "${ADMIN_PASSWORD}" --type SecureString --overwrite | jq .

aws ssm put-parameter --name ${SSM_KEY}/slack_token --value "${SLACK_TOKEN}" --type SecureString --overwrite | jq .

aws ssm put-parameter --name ${SSM_KEY}/datadog_api_key --value "${DATADOG_API_KEY}" --type SecureString --overwrite | jq .
aws ssm put-parameter --name ${SSM_KEY}/datadog_app_key --value "${DATADOG_APP_KEY}" --type SecureString --overwrite | jq .

aws ssm put-parameter --name ${SSM_KEY}/logzio_token --value "${LOGZIO_TOKEN}" --type SecureString --overwrite | jq .
```

## replace

```bash
# replace
# create s3 bucket
# create dynamodb table
./replace.sh
```
