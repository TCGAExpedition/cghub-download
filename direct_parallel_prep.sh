#!/bin/bash
requests_dir=/supercell/bam_requests/active_downloads
master_requests_file=bam_status_COAD_WGS_noheader.tsv
requests_file_stub=bam_status_COAD_WGS

max_gtdownloads=6

cd $requests_dir
lines=`cat $master_requests_file | wc -l`
lines_per_file=`python -c "from math import ceil; print int(ceil($lines/${max_gtdownloads}.0))"`
split -d -l $lines_per_file $master_requests_file

for i in $( ls x[0-9][0-9] ); do cat header.tsv > $requests_file_stub.$i.tsv ; cat $i >> $requests_file_stub.$i.tsv; rm -f $i; done

