#!/usr/bin/sh

# export simplified requirements
poetry export -f requirements.txt --without-hashes | sed -e 's/;.*//' >requirements.txt

cd infra/terraform || exit
terraform apply -auto-approve
