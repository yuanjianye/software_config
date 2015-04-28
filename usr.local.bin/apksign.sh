#!/bin/bash

#You can run this script in any path.
SCRIPT_FILE=$0
while [ -L $SCRIPT_FILE ]
do
    SCRIPT_FILE=`readlink $SCRIPT_FILE`
done
SCRIPT_DIR=`dirname $SCRIPT_FILE`

if [ $# != 1 ]; then 
    echo "USAGE: $0 FILENAME"
    exit
fi
FILE_NAME=$1
OUTPUT_NAME=${FILE_NAME%%.*}-signed.apk
java -jar $SCRIPT_DIR/signapk.jar $SCRIPT_DIR/platform.x509.pem $SCRIPT_DIR/platform.pk8 $FILE_NAME $OUTPUT_NAME
