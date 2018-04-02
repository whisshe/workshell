#!/bin/bash
#定义输出的颜色
str=abc
function color(){
    read -p "which color: " color
    echo "1:red 2:green"
    if [ $color == 1 ];then
	echo -e "\033[41;37m $str\033[0m"
    else 
        echo -e "\033[4$color;37m $str\033[0m"
    fi
}

color
