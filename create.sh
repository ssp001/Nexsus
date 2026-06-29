#!/usr/bin/sh
NAME="terraform_destory"

pwd

cd terraform || exit 1
echo "$NAME sell scripit has started"

terraform init
terraform plan

echo "$NAME shfile opration completed"