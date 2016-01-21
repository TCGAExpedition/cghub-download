#!/bin/bash

# make sure single argument and argument is absolute path
if [[ ($# -ne 3) || (${1:0:1} != "/") ]]; then
    echo "Usage: ./cghub_download <full path to CGHUB TSV file dir> <# GT instances> <# threads per GT instance>"
    exit
fi
export TMPDIR=/local/tmp
python_script=GT_Download_02_19_2015_3.8.7.py

path=/supercell2
final_dir=$path/tcga_downloads

bam_request=$path/bam_requests
bam_request_active=$bam_request/active_downloads
bam_request_finished=$bam_request/finished_downloads

genetorrent=$path/bam_gt
key_file=$genetorrent/key_firehose6/cghub.key
genetorrent_active=$genetorrent/active_downloads
genetorrent_finished=$genetorrent/finished_downloads

tsv_dir=$1
gt_instances=$2
gt_threads=$3

find $tsv_dir -name '*.tsv' | sort >  $bam_request_active/tsv_list

while read tsv; do
    # extract tsv file name from full path
    local_tsv=`echo $tsv | awk -F "/" '{print $NF}'`
    # remove .tsv extension from tsv file name
    requests_file_stub=`echo $local_tsv | awk -F ".tsv" '{print $1}'`
    label=`awk -F "\t" 'NR==2 {print tolower($3)"-"tolower($8)}' $tsv | cut -f 3 -d '-' --complement`

    $genetorrent_active/direct_parallel_prep.sh $bam_request_active $tsv $gt_instances

    finished="false"
    while [[ "$finished" == "false" ]]; do 
	cd $genetorrent_active
	./direct_parallel.sh $python_script $final_dir $key_file $genetorrent_active $bam_request_active $tsv $gt_threads
	cd $bam_request_active
	total_downloads=`wc -l < ${requests_file_stub}_noheader.tsv`
	finished_downloads=`grep -i finished ${requests_file_stub}.x*.tsv | wc -l`
	suppressed_downloads=`grep -i suppressed ${requests_file_stub}.x*.tsv | wc -l`
	let completed_downloads=finished_downloads+suppressed_downloads
	if [[ "$completed_downloads" -eq "$total_downloads" ]]; then
	    finished="true"
	fi
    done

    grep -hv pgrr_file_path ${requests_file_stub}.x*.tsv > ${requests_file_stub}_noheader.tsv
    cat header.tsv ${requests_file_stub}_noheader.tsv > finished_${requests_file_stub}.tsv
    dir=$bam_request_finished/$label 
    if ! [[ -d "$dir" ]]; then 
	mkdir -p "$dir/intermediate_files"
	mkdir "$dir/final_files"
    fi
    mv finished_${requests_file_stub}.tsv $dir/final_files
    mv $local_tsv $dir
    mv ${requests_file_stub}.x*.tsv ${requests_file_stub}_noheader.tsv $dir/intermediate_files

    cd $genetorrent_active
    dir=$genetorrent_finished/$label 
    if ! [[ -d "$dir" ]]; then 
	mkdir "$dir"
    fi
    mv gtdownload.*.log download_rate.out $dir    
    echo "Finished with $local_tsv, removing $tsv"
    rm -f $tsv

done <$bam_request_active/tsv_list

