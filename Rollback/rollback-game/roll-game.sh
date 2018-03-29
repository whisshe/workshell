#!/bin/bash
#game一键回退
pwd=`pwd`
color(){
	echo -e "\033[3$1m $2\033[0m"
}

function copyright(){
    echo -e "\033[34m##################"
    echo  " 喜扣游戏回退平台 "
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
    awk 'BEGIN {FS="%"} {printf("\033[0;31m% 3s \033[m | %10s\n",$1,$2)}' $pwd/game.list
    underline
    echo -e '\033[36m输入序号选择项目，输入q退出\033[0m'
    read -p '[*] 选择项目: ' number
    res="$pwd/game.resource"
    name=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $2}}' $res)
    dest_machine=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $3}}' $res)
    dest_directory=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $4}}' $res)
    user=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $5}}' $res)

    case $number in
        [0-9]|[0-9][0-9])
        cd $pwd || exit 1

        #选择回退的版本
        ssh $user@$dest_machine "cd $dest_directory;ls|grep $name|tail -n3" > $name.version 
        ssh $user@$dest_machine "cd $dest_directory;ls|grep $name|tail -n3"|awk -F$name- '{print $2 }' 
        color 4 填入后六位选择回退的版本 
        read gameVersion
	gameDate=`cat $name.version|grep $gameVersion|awk -F$name- '{print $2}'`
	gameVersionNum=`cat $name.version| grep $gameVersion|wc -l`
	if [ $gameVersionNum -eq 1 ];then
            case $gameVersion in 
                [0-9]?????)
		    #到对应机器删掉目前的软连接，然后替换成指定版本的项目目录
			ssh $user@$M "cd $dest_game_directory;rm $name;ln -s $dest_directory/$name-$gameDate ./$name"
			rollStatus=`ssh $user@$M "[ ! -d $dest_directory/../$name ] || echo yes"` 
			if [[ $rollStatus == yes ]];then
			    color 6 "##################"
			    color 6 "$M $name已经回退至$gameDate版本"
			    color 6 "##################" 
			else 
			    color 1 "$M $name回退的目录错误"
			fi
		    ;;
	    esac
	else	
	    color 1 "$gameVersion is Wrong"
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
