#!/bin/bash

TIME=`date +%Y%m%d-%H%M%S`
BACKUP=0
pwd=`pwd`

while getopts 'b' OPT; do
    case $OPT in
        b)
            BACKUP=1;;
    esac
done

function copyright(){
    echo "##################"
    echo  " 喜扣游戏发布平台 "
    echo "##################"
    echo
}

function underline(){
    echo "-----------------------------------------"
}

function main(){

while [ True ];do

    echo "序号 | 游戏名"
    underline
    awk 'BEGIN {FS="%"} {printf("\033[0;31m% 3s \033[m | %10s\n",$1,$2)}' $pwd/game.list
    underline
    echo -e "\033[31m先去线上进行备份\033[0m"
    echo -e '\033[36m输入序号选择游戏，输入q退出\033[0m'
    read -p '[*] 选择游戏: ' number
    res="$pwd/game.resource"
    name=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $2}}' $res)
    src_method=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $3}}' $res)
    src=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $4}}' $res)
    mod=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $5}}' $res)
    dest_machine=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $6}}' $res)
    dest_directory=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $7}}' $res)
    ppush=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $8}}' $res)
    gamekill=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $9}}' $res)
    gamestart=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $10}}' $res)


    case $number in
        [0-9]|[0-9][0-9]|[0-9][0-9][0-9])
            cd $pwd || exit 1

            #backup
            if [ $BACKUP == 1 ]; then
                tar zcvf /home/deploy/game_dep/bak/${name}-${TIME}.tar.gz $name
            fi
            #pull之前checkout果园的.env
            if [ $name == gyhd ];then 
                ./beforepull/gyhd.sh || exit 1
            elif [ $name == hbhd ];then 
                ./beforepull/hbhd.sh || exit 1
            fi 
            #pull
            if [ $src_method == "rsync" ]; then
            #--exclude-from 忽略这个文件里面的字符，不进行同步
               echo -e "\n" >> $pwd/deploy.log
               echo $TIME,$dest_machine >> $pwd/deploy.log
               rsync -avu --delete --exclude-from=./exclude.list   $src/ $name >> $pwd/deploy.log || exit 1
            elif [ $src_method == "git" ]; then
                if [ -d $name ]; then
                    cd $name
                    git checkout master || exit 1
                    echo -e "\n" >> $pwd/deploy.log
                    echo $TIME,$dest_machine >> $pwd/deploy.log
                    git pull >> $pwd/deploy.log || exit 1
                else
                    git clone $src $name || exit 1
                fi
            fi


            #modify
            cd $pwd || exit 1
            cd $name || exit 1
            $pwd/modify/$mod $pwd/$name || exit 1

            #push
            cd $pwd || exit 1
            for M in $dest_machine; do
                    rsync -avu --delete --exclude-from=exclude.list $name/ game@$M:$dest_directory/${name}-${TIME} || (echo "rsync game to $M failure,exit"; exit 1)
    		    echo $TIME >> ~/game_dep/postpush/time/${name}.time
                    #deploy
                    rsync -avu --delete postpush game@$M:/home/game/ || (echo "rsync postpush to $M failure, exit"; exit 1)
                    sleep 1
                    ansible -i ./hosts -u game $name -m shell -a "/home/game/postpush/$ppush" || exit 1
                    sleep 3
		    if [[ $name == sdmj|| $M == sybphd ]];then
		        ssh game@$M "cd /home/game/postpush/start;./$gamekill;./$gamestart"
                    fi
            done

        ;;
        "q"|"quit")
            exit
        ;;

        *)
            echo "Input error!!"
        ;;
    esac
done
}

copyright
main
