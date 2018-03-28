#!/bin/bash
#code一键回退
pwd=`pwd`
color(){
	echo -e "\033[3$1m $2\033[0m"
}

function copyright(){
    echo -e "\033[34m##################"
    echo  " 喜扣代码回退平台 "
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
    awk 'BEGIN {FS="%"} {printf("\033[0;31m% 3s \033[m | %10s\n",$1,$2)}' $pwd/code.list
    underline
    echo -e '\033[36m输入序号选择项目，输入q退出\033[0m'
    read -p '[*] 选择项目: ' number
    res="$pwd/code.resource"
    name=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $2}}' $res)
    dest_machine=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $3}}' $res)
    dest_machines=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $4}}' $res)
    dest_directory=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $5}}' $res)
    user=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $6}}' $res)

    case $number in
        [0-9]|[0-9][0-9])
        cd $pwd || exit 1

        #选择回退的版本
        ssh $user@$dest_machine "cd $dest_directory;ls|grep $name|tail -n3" > $name.version 
        ssh $user@$dest_machine "cd $dest_directory;ls|grep $name|tail -n3"|awk -F$name- '{print $2 }'|awk -F. '{print $1}' 
        color 4 填入后六位选择回退的版本 
        read codeVersion
	codeDate=`cat $name.version|grep $codeVersion|awk -F$name- '{print $2}'|awk -F. '{print $1}'`
	RollbackVersion=`cat $name.version|grep $codeVersion`
	codeVersionNum=`cat $name.version| grep $codeVersion|wc -l`
	if [ $codeVersionNum -eq 1 ];then
            case $codeVersion in 
                [0-9]?????)
		    #到对应机器的bak目录解压，然后替换掉项目目录
		    for M in $dest_machines;do
			ssh $user@$M "cd $dest_directory;tar zxf $RollbackVersion;rm -fr ../$name;mv $name ../"
			rollStatus=`ssh $user@$M "[ ! -d $dest_directory/../$name ] || echo yes"` 
			if [[ $rollStatus == yes ]];then
			    color 6 "##################"
			    color 6 "$M $name已经回退至$codeDate版本"
			    color 6 "##################" 
			else 
			    color 1 "$M $name回退的目录错误"
			fi
		    done
		    ;;
	    esac
	else	
	    color 1 "$codeVersion is Wrong"
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
