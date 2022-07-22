#!/usr/bin/sh

ROOT=${PWD}

./scripts/create_packages.sh

cd infra/terraform
terraform apply -auto-approve

cd $ROOT
rm -rf ./src/package
