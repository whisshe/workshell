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
    echo  " 喜扣代码发布平台 "
    echo "##################"
    echo
}

function underline(){
    echo "-----------------------------------------"
}

function main(){

while [ True ];do

    echo "序号 | 项目名"
    underline
    awk 'BEGIN {FS="%"} {printf("\033[0;31m% 3s \033[m | %10s\n",$1,$2)}' $pwd/project.list
    underline
    echo -e '\033[31m先去线上进行备份\033[0m'
    echo -e '\033[36m输入序号选择项目，输入q退出\033[0m'
    read -p '[*] 选择项目: ' number
    res="$pwd/project.resource"
    name=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $2}}' $res)
    prepull=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $3}}' $res)
    build=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $4}}' $res)
    dest_machine=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $5}}' $res)
    dest_directory=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $6}}' $res)
    formal_dir=$(awk -v num=$number 'BEGIN {FS="%"} {if($1 == num) {print $7}}' $res)

    case $number in
        [0-9]|[0-9][0-9]|[0-9][0-9][0-9])
            cd $pwd || exit 1

            #backup
            if [ $BACKUP == 1 ]; then
                tar zcvf bak/${name}-${TIME}.tar.gz $name
            fi

            #pre pull
            cd $name && ($pwd/prepull/$prepull $pwd/$name || exit 1)

            #pull
            cd $pwd || exit 1
            if [ -d $name ]; then
                cd $name
                git checkout master || exit 1
                git pull || exit 1
            else
                git clone git@git:/home/git/${name}.git || exit 1
            fi

            #build
            cd $pwd || exit 1
            cd $name || exit 1
            $pwd/build/$build $pwd/$name || exit 1

            #push
            cd $pwd || exit 1
            for M in $dest_machine; do
                #########添加判断更新pkgame-libs
                echo $name|grep pkgame-libs 2>&1 > /dev/null
                if [[ $? -eq 0 ]];then	
                	rsync -avu --delete $name/ root@xkdev:$dest_directory/${name}-${TIME} || (echo "rsync to xkdev failure, exit"; exit 1)
			ansible -i hosts -u root $name -m shell -a "rm $formal_dir -fr"
			ansible -i hosts -u root $name -m shell -a "ln -s $dest_directory/${name}-${TIME}  $formal_dir"
		else
                        rsync -avu --delete $name/ game@$M:$dest_directory/${name}-${TIME} || (echo "rsync to $M failure, exit"; exit 1)
			ansible -i hosts -u game $name -m shell -a "rm $formal_dir -fr"
			ansible -i hosts -u game $name -m shell -a "ln -s $dest_directory/${name}-${TIME}  $formal_dir"
		fi
################################
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
