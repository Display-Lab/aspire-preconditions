#!/usr/bin/env bash

ZIPFILE=/mnt/aspire/PCRC_0088_Performance_Measures.zip
DEST=/tmp/aspire

# Check if source data available.
if [[ ! -e ${ZIPFILE} ]]; then
  echo "${ZIPFILE} not found."
  exit 1
fi

# Create directory to hold resulting data.
mkdir -p ${DEST}
chown grosscol:grosscol ${DEST}

# Taken from data_munge.sh
read -r -d '' AWK_MUNGE <<'MUNGE'
  BEGIN {FS=","; OFS=","}
  BEGIN {print "Measure_Name","Staff_Number","Month","Passed_Count","Denominator"} 
  {denom=$6-$9; if(denom > 9) {print $2,$3,$5,$7,denom}}
MUNGE


# Unzip directly into data munging.
echo "Unzipping and munging."

DATAFILE=$(zipinfo -1 ${ZIPFILE})
unzip -p ${ZIPFILE} ${DATAFILE} | \
  awk "${AWK_MUNGE}" > ${DEST}/mpog-munged.csv 

# Additionally need to do this to sort and uniq the rows:
(head -n 1 mpog-munged.csv && tail -n +2 mpog-munged.csv | sort -u -t, -k1,3 ) > mpog-unfd.csv
echo "Done."
