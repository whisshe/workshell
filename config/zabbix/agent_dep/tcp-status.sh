metric=$1
tmp_file=/tmp/tcp_status.txt
/bin/ss -ant|awk '{a[$1]++}END{for (i in a)print i,a[i]}'  > $tmp_file

case $metric in
 listen)
          output=$(awk '/LISTEN/{print $2}' $tmp_file)
             echo $output
        ;;
   established)
          output=$(awk '/ESTAB/{print $2}' $tmp_file)
             echo $output
        ;;
   timewait)
          output=$(awk '/TIME-WAIT/{print $2}' $tmp_file)
             echo $output
        ;;
   closing)
          output=$(awk '/CLOSING/{print $2}' $tmp_file)
             echo $output
        ;;
   closewait)
          output=$(awk '/CLOSE-WAIT/{print $2}' $tmp_file)
             echo $output
        ;;
   lastack)
          output=$(awk '/LAST-ACK/{print $2}' $tmp_file)
             echo $output
         ;;
   finwait1)
          output=$(awk '/FIN-WAIT1/{print $2}' $tmp_file)
             echo $output
         ;;
   finwait2)
          output=$(awk '/FIN-WAIT2/{print $2}' $tmp_file)
             echo $output
         ;;
   closed)
          output=$(awk '/CLOSED/{print $2}' $tmp_file)
             echo $output
        ;;
   synrecv)
          output=$(awk '/SYN-RECV/{print $2}' $tmp_file)
             echo $output
        ;;
   synsent)
          output=$(awk '/SYN-SENT/{print $2}' $tmp_file)
             echo $output
        ;;
         *)
          echo -e "\e[033mUsage: sh  $0 [closed|closing|closewait|synrecv|synsent|finwait1|finwait2|listen|established|lastack|timewait]\e[0m"
   
esac
