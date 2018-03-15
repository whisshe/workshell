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
    echo  " CDN资源发布平台 "
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
    echo -e '\033[36m输入序号选择游戏，输入q退出\033[0m'
    read -p '[*] 选择游戏: ' number
    res="$pwd/game.resource"
    name=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $2}}' $res)
    src=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $3}}' $res)
    dest_directory=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $4}}' $res)
    ppush=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $5}}' $res)

    case $number in
        [0-9]|[0-9][0-9]|[0-9][0-9][0-9])
            cd $pwd || exit 1
            #backup
            if [ $BACKUP == 1 ]; then
               tar zcvf   ./bak/${name}-${TIME}.tar.gz $name
            fi
            #pull
               rsync -avu --delete    $src/ $name 
            #不存在这个文件夹时，创建文件夹
            #将文件夹名写入文件中
               echo $name > a
               rsync -avu  a root@apia:/data/res-s/
               rsync -avu mkdir.sh root@apia:/data/res-s/
               ansible -i hosts -u root apia -a '/data/res-s/mkdir.sh'

            #push
                rsync -avu --delete $name/ root@apia:/data/res-s/$name/resource || (echo "rsync to $M failed,exit" ;exit 1)
		echo -e '\033[32m####################################'
		echo           "赶紧去刷新CDN"
		echo -e '####################################\033[0m'


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
