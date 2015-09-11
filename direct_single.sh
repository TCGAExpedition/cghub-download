#!/bin/bash
python_script=GT_Download_02_19_2015.py
threads=1
final_dir=/supercell/tcga_downloads
key_file=/supercell/bam_gt/key_firehose6/cghub.key
requests_dir=/supercell/bam_requests/active_downloads
requests_file=bam_status_LGG_RNA-Seq.x21.tsv
log_file=gtdownload
script_dir=`pwd`

cd $requests_dir
python $script_dir/$python_script -v -n "$threads" -t "$final_dir" -C "$key_file" -d "$requests_dir" $requests_file >> $script_dir/$log_file.$requests_file.log

