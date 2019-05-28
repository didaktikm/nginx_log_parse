#!/usr/bin/env bash

clear   

FILES='access.log'
LRUN=$(cat prev)

LCYAN='\033[1;36m'     #  ${LCYAN}
NORMAL='\033[0m'		# ${NORMAL}

COUNT_PER_SEC='count_per_sec.tmp'
COUNT_BY_CODE='count_by_code.tmp'
REQUEST_BY_FREQUENCY='request_by_frequency.tmp'
  
  # for file in $FILES; do
		tail -n +$LRUN $FILES | awk '($4$5)' >> total.tmp
		# done
		# grep -F "15:55" total.tmp >> test.log
	
  awk '{print $4$5}' total.tmp | sort | uniq -c | sort -rn -o $COUNT_PER_SEC &
  awk '{print $9}' total.tmp | sort | uniq -c | sort -rn -o $COUNT_BY_CODE &
  awk '{ ind = match($6$7, /\?/)
         if (ind > 0)
           print substr($6$7, 0, ind)
         else
           print $6$7
       }' total.tmp | sort | uniq -c | sort -rn -o $REQUEST_BY_FREQUENCY
  
      echo -e "${LCYAN}Среднее количество запросов в секунду ${NORMAL}"
      awk '{s += $1} END {print "\033[0;33m" s/NR}' $COUNT_PER_SEC
   
      echo -e "${LCYAN}Максимальное количество запросов в секунду ${NORMAL}"
      awk 'NR == 1 {print "\033[0;33m" $1}' $COUNT_PER_SEC
     
      echo -e "${LCYAN}Коды ответа сервера ${NORMAL}"
      awk '{print "\033[0;33m" $2, $1}' $COUNT_BY_CODE
  
      echo -e "${LCYAN}Топ запросов ${NORMAL}"
      awk 'FNR <= 5 {print "\033[0;33m" $1, $2}' $REQUEST_BY_FREQUENCY
	  
	  tput sgr0
	  
	  wc -l access.log | awk '{print $1}' > prev
	  
	  CPS=$(awk '{s += $1} END {print "\033[0;33m" s/NR}' $COUNT_PER_SEC)
	  MPS=$(awk 'NR == 1 {print "\033[0;33m" $1}' $COUNT_PER_SEC)
	  CBC=$(awk '{print "\033[0;33m" $2, $1}' $COUNT_BY_CODE)
	  RBF=$(awk 'FNR <= 5 {print "\033[0;33m" $1, $2}' $REQUEST_BY_FREQUENCY)
	  
	  
	  echo -e "Среднее количество запросов в секунду:$CPS \n Максимальное количество запросов в секунду:$MPS\n Коды ответа сервера:$CBC\n Топ запросов:$RBF\n" | mail -s "Nginx logs" user@mail.com
	  # echo "$LRUN"  
	  # rm -rf *.tmp