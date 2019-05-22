#!/usr/bin/env bash

FILES='access.log'

COUNT_PER_SEC='count_per_sec.tmp'
COUNT_BY_CODE='count_by_code.tmp'
REQUEST_BY_FREQUENCY='request_by_frequency.tmp'
REFERER_BY_FREQUENCY='referer_by_frequency.tmp'

  find . -name '*.tmp' -type f -delete
  
  for file in $FILES; do
    awk '($4$5)' $file >> total.tmp
  done

  awk '{print $4$5}' total.tmp | sort | uniq -c | sort -rn -o $COUNT_PER_SEC &
  awk '{print $9}' total.tmp | sort | uniq -c | sort -rn -o $COUNT_BY_CODE &
  awk '{ ind = match($6$7, /\?/)
         if (ind > 0)
           print substr($6$7, 0, ind)
         else
           print $6$7
       }' total.tmp | sort | uniq -c | sort -rn -o $REQUEST_BY_FREQUENCY &
  awk '{ ind = match($11, /\w\//)
         if (ind > 0) 
           print substr($11, 0, ind)
         else
           print $11
       }' total.tmp | sort | uniq -c | sort -rn -o $REFERER_BY_FREQUENCY
  wait

      echo "Average of requests per second"
      awk '{s += $1} END {print s/NR}' $COUNT_PER_SEC 
   
      echo "Max of requests per second"
      awk 'NR == 1 {print $1}' $COUNT_PER_SEC
     
      echo "Codes"
      awk '{print $2, $1}' $COUNT_BY_CODE
  
      echo "Top of Requests"
      awk 'FNR <= 5 {print $1, $2}' $REQUEST_BY_FREQUENCY
