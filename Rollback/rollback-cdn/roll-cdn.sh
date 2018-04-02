#!/bin/bash
#cdn一键回退
pwd=`pwd`
color(){
	echo -e "\033[3$1m $2\033[0m"
}

function copyright(){
    echo -e "\033[34m##################"
    echo  " 喜扣CDN回退平台 "
    echo -e "##################\033[0m"
    echo
}

function underline(){
    echo "-----------------------------------------"
}

function main(){

while [ True ];do

    echo "序号 | 项目名"
    underline
    awk 'BEGIN {FS="%"} {printf("\033[0;31m% 3s \033[m | %10s\n",$1,$2)}' $pwd/cdn.list
    underline
    echo -e '\033[36m输入序号选择项目，输入q退出\033[0m'
    read -p '[*] 选择项目: ' number
    res="$pwd/cdn.resource"
    name=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $2}}' $res)
    dest_cdnroot_directory=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $3}}' $res)
    dest_cdnbak_directory=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $4}}' $res)

    case $number in
        [0-9]|[0-9][0-9])
        cd $pwd || exit 1

        #选择回退的版本
        [ -d cdnVersion ] || mkdir cdnVersion
        ssh game@apia "cd $dest_cdnbak_directory;ls|grep $name|tail -n3" > cdnVersion/$name.version 
        ssh game@apia "cd $dest_cdnbak_directory;ls|grep $name|tail -n3"|awk -F${name}cdn- '{print $2 }' 
        color 4 填入后六位选择回退的版本 
        read cdnVersion
	cdnDate=`cat cdnVersion/$name.version|grep $cdnVersion|awk -F${name}cdn- '{print $2}'`
	cdnVersionNum=`cat cdnVersion/$name.version| grep $cdnVersion|wc -l`
	if [ $cdnVersionNum -eq 1 ];then
		ssh game@apia "rm ${dest_cdnroot_directory}/resource;ln -s ${dest_cdnbak_directory} ${dest_cdnroot_directory}/resource"
		ssh game@apia "ls -l ${dest_cdnroot_directory}"
	else	
	    color 1 "输入的版本号$cdnVersion is Wrong"
	fi
	;;
    q)
	exit
	;;    
	*)
	color 1 输入的序号错误
	;;
    esac
done
}

copyright
main
