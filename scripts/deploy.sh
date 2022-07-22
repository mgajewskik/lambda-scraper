#!/usr/bin/sh

ROOT=${PWD}

poetry export -f requirements.txt --output requirements.txt --without-hashes

# parse requirements.txt to remove unwanted strings
sed -i -e 's/;.*//' requirements.txt

./scripts/create_lambda_package.sh

if [ "$1" = "layer" ]
then
    echo "Deploying with layers package."
    ./scripts/create_layers_package.sh
fi

cd infra/terraform
terraform apply -auto-approve
