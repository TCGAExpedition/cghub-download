#!/bin/bash
requests_dir=$1
tsv=$2
max_gtdownloads=$3

# extract tsv file name from full path
local_tsv=`echo $tsv | awk -F "/" '{print $NF}'`
# remove .tsv extension from tsv file name
requests_file_stub=`echo $local_tsv | awk -F ".tsv" '{print $1}'`

master_requests_file=${requests_file_stub}_noheader.tsv

cd $requests_dir
# make local copy of tsv file in active requests directory
cp -p $tsv $local_tsv
# remove header line to create tsv master file for downloads
grep -hv pgrr_file_path $local_tsv > $master_requests_file

lines=`cat $master_requests_file | wc -l`
lines_per_file=`python -c "from math import ceil; print int(ceil($lines/${max_gtdownloads}.0))"`
split -d -l $lines_per_file $master_requests_file

for i in $( ls x[0-9][0-9] ); do cat header.tsv > $requests_file_stub.$i.tsv ; cat $i >> $requests_file_stub.$i.tsv; rm -f $i; done

