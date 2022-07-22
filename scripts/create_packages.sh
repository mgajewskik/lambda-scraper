#!/usr/bin/sh

ROOT=${PWD}

rm -rf ./src/package

pip install --target ./src/package/python -r requirements.txt

cd src/package; zip -r ./layers.zip *
cd $ROOT
cd src/lambda-scraper; zip -r ../package/lambda.zip *
