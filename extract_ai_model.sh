#!/bin/bash
storage_path="/jxserving/storage"
ai_model_path="/jxserving/storage/models"
mkdir -p $ai_model_path

if [ $# != 1 ] ; then
    echo "USAGE: $0 [ai-model].tar.gz"
    echo " e.g.: $0 226a7354795692913f24bee21b0cd387-1.tar.gz"
    exit 1;
fi

name=$1

if [ ! -f $storage_path/$name ]; then
    echo $name "target model file do not exist"
    echo $name "try to fetch model file ..."

    echo $name "fetch model file successfully"
    exit 1;
fi

head=`echo $name |sed 's/.tar.gz//g'|sed 's/-/ /g'|awk '{ print $1 }'`
tail=`echo $name |sed 's/.tar.gz//g'|sed 's/-/ /g'|awk '{ print $2 }'`
mkdir -p $ai_model_path/$head/$tail
tar -zxvf $storage_path/$name --strip-components 1 -C $ai_model_path/$head/$tail
