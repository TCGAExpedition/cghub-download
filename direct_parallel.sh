#!/bin/bash

python_script=$1
final_dir=$2
key_file=$3
script_dir=$4
requests_dir=$4
tsv=$5
threads=$6

# extract tsv file name from full path
local_tsv=`echo $tsv | awk -F "/" '{print $NF}'`
# remove .tsv extension from tsv file name
requests_file_stub=`echo $local_tsv | awk -F ".tsv" '{print $1}'`

cd $requests_dir

for requests_file in $requests_file_stub.x[0-9][0-9].tsv; do
python $script_dir/$python_script -v -n "$threads" -t "$final_dir" -C "$key_file" -d "$requests_dir" $requests_file >> $script_dir/gtdownload.$requests_file.log &
sleep 10
done
wait
