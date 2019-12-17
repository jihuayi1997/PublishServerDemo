#!/bin/bash


for line in `cat signLists.txt`
do
    echo $line uploading
    curl -F file=@$line http://192.168.80.154:8888/upload
    echo $line downloading
    curl -o $line http://192.168.80.154:8080/$line
done
