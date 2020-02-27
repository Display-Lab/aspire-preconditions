#! /usr/bin/env bash

# cat mpog-data.csv into this script
# redirect to destination file. E.g.
#  cat mpog-data.csv | ./data_munge.sh > mpog-munged.csv

read -r -d '' AWK_SCRIPT <<'USPARQL'
  BEGIN {FS=","; OFS=","}
  BEGIN {print "Measure_Name","Staff_Number","Month","Passed_Count","Denominator"} 
  {denom=$6-$9; if(denom > 9) {print $2,$3,$5,$7,denom}}
USPARQL

awk "${AWK_SCRIPT}" 
