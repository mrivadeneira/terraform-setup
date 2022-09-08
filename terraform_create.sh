# write a env.sh file with the following values:
# $ export ARM_CLIENT_ID="<APPID_VALUE>"
# $ export ARM_CLIENT_SECRET="<PASSWORD_VALUE>"
# $ export ARM_SUBSCRIPTION_ID="<SUBSCRIPTION_ID>"
# $ export ARM_TENANT_ID="<TENANT_VALUE>"
bash env.sh;

az login --use-device-code;

az account set --subscription "698b5510-794f-4f05-aa63-c8b8c39a396a";

az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/698b5510-794f-4f05-aa63-c8b8c39a396a"

#Initialize terraform configuration
terraform init;
terraform fmt;
terraform validate;
terraform apply;

#terraform destroy

