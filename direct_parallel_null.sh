#!/bin/bash
export TMPDIR=/local/tmp
which gtdownload
python_script=GT_Download_02_19_2015_3.8.7.py
final_dir=/supercell2/bam_test2
key_file=/supercell2/bam_gt/key_firehose6/cghub.key
requests_dir=/supercell2/bam_requests/testing_dir2
requests_file_stub=bam_status_LIHC_WXS 
log_file=gtdownload
script_dir=`pwd`

threads=1
cd $requests_dir

for requests_file in $requests_file_stub.x[0-9][0-9].tsv; do
    python $script_dir/$python_script -v -N -n "$threads" -t "$final_dir" -C "$key_file" -d "$requests_dir" $requests_file >> $script_dir/$log_file.$requests_file.null.log &
sleep 10
done
wait
