#!/bin/bash
python_script=GT_Download_02_19_2015.py
threads=24
final_dir=/supercell2/tcga_downloads
key_file=/supercell2/bam_gt/key_firehose6/cghub.key
requests_dir=/supercell2/bam_requests/active_downloads
requests_file=bam_status_OV_WXS.x04.tsv
log_file=outputDirect
script_dir=`pwd`

cd $requests_dir
python $script_dir/$python_script -v -n "$threads" -t "$final_dir" -C "$key_file" -d "$requests_dir" $requests_file > $script_dir/$log_file.$requests_file.log

requests_file=bam_status_OV_WXS.x05.tsv

python $script_dir/$python_script -v -n "$threads" -t "$final_dir" -C "$key_file" -d "$requests_dir" $requests_file > $script_dir/$log_file.$requests_file.log
