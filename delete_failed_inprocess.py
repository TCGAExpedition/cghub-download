#!/bin/env python
# How to create "pgrr_file_path":
# <disease_abbr_lowCase>/<patient_barcode>/<sample_barcode>/<library_type>/<center> _<platform_name>/<analysis_id>/
# where (columns in bam_status.tsv file):
# <disease_abbr_lowCase> - "disease" (C) to lower case
# <patient_barcode> - "barcode" (B) first 12 chars
# <sample_barcode> - "barcode" (B) first 15 chars
# <library_type> - "library_type" (H)
# <center> - use "CGHub"
# <platform_name> - "platform_name" (L)
# <analysis_id> - "analysis_id" (Q) - added automatically by genetorrent

#EXAMPLE ENTRY:
#study	barcode	disease	disease_name	sample_type	sample_type_name	analyte_type	library_type	center	center_name	platform	platform_name	assembly	filename	files_size	checksum	analysis_id	aliquot_id	participant_id	sample_id	tss_id	sample_accession	published	uploaded	modified	state	side	start_time	end_time	download_attempt_num	status	overall_rate_(MB/s)	pgrr_file_path
#TCGA	TCGA-AA-3693-01A-01D-0957-02	COAD	Colon adenocarcinoma	TP	1	DNA	WGS	HMS-RK	HMS-RK	ILLUMINA	Illumina	HG18	TCGA-AA-3693-01A-01D-0957-02_IlluminaGAII-DNASeq_whole.bam	5478357979	75e52ca4c6d5de2d40556a0999813a19	3a9f1142-0d5b-4583-a570-4da8e1455e0c	232d0a9b-c1e1-435a-bb5f-d346243d420e	33522271-b2ca-4da4-a942-501ab9117c51	e2843875-a4de-4d90-bda2-0fbbc929757f	AA	SRS097064	2013-01-12	2011-06-16	2013-05-16	Live		09/08/15 04:45 PM	09/08/15 04:50 PM	1	Finished	17.5302013423	coad/TCGA-AA-3693/TCGA-AA-3693-01/WGS/CGHub_Illumina/3a9f1142-0d5b-4583-a570-4da8e1455e0c	

import sys, csv, os, glob

if len(sys.argv) != 2:
    print "Usage: ", str(sys.argv[0]), " <filename>"
    sys.exit()
 
file=str(sys.argv[1])
with open(file, 'rb') as fh:
    reader = csv.reader(fh, delimiter='\t')
    for row in reader:
        if 'InProcess' in row or 'Failed' in row:
# pgrr_file_path must never be empty!  
# But we explicitly set parts of the pgrr_file_path, so should be safe
            pgrr_file_path = row[2].lower() + '/' + row[1][:12] + '/' + row[1][:15] + '/' + row[7] + '/CGHub_' + row[11] + '/' + row[16]
            path =  "/supercell/tcga_downloads/" + pgrr_file_path
            print "Paths to remove if present: " + path
            remove = glob.glob(path + "*")
            for item in remove:
                print "Removing " + item
                os.system("rm -rf " + item)
