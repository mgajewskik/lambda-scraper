#!/usr/bin/sh

ROOT=${PWD}

rm -rf $ROOT/src/package/lambda.zip
echo "Removing old lambda package"

cd $ROOT/src/lambda-scraper; zip -r ../package/lambda.zip *
