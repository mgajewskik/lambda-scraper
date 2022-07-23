#!/usr/bin/sh

ROOT=${PWD}

rm -rf $ROOT/src/package/python
rm -rf $ROOT/src/package/layers.zip
echo "Removing old layers package"

pip install --target $ROOT/src/package/python/lib/python3.9/site-packages -r requirements.txt

cd $ROOT/src/package; zip -r ./layers.zip *

rm -rf $ROOT/src/package/python
