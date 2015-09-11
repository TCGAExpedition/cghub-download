#!/bin/bash
python_script=GT_Download_02_19_2015.py
final_dir=/supercell2/bam_test
key_file=/supercell2/bam_gt/key_firehose6/cghub.key
requests_dir=/supercell2/bam_requests/active_downloads
requests_file_stub=prep_bam_status_GBM_WGS
log_file=gtdownload
script_dir=`pwd`

threads=1
cd $requests_dir

for requests_file in $( ls $requests_file_stub.x[0-9][0-9].tsv ); do
python $script_dir/$python_script -v --null-storage -n "$threads" -t "$final_dir" -C "$key_file" -d "$requests_dir" $requests_file >> $script_dir/$log_file.$requests_file.log &
done
wait
