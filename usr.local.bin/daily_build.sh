#!/bin/bash

function make_product
{
    cd /home/jinglun/$1
    svn up --force --accept mine-full 
    svn st >/home/ftp/log/svnst-$1-`date "+%F_%H.%M.%S"`.log
    ./make.sh $1 rebuild_all 2>&1|tee /home/ftp/log/make-$1-`date "+%F_%H.%M.%S"`.log 
}

make_product m201
make_product k200
make_product n200
