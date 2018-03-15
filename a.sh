  #"please input a word: " $1
lenth=$((`echo $1|wc -m` - 1))
width=40
if [ $lenth -lt $width ];then
    F=$((($width-lenth)/2))
    A=$(($width-F-lenth))
else
    echo error
fi
i=1
b=' '
while [ $i -le $F ];do
    c=$c$b
    i=$((i+1))
done
i=1
while [ $i -le $A ];do
    d=$d$b
    i=$((i+1))
done
str=$c$1$d
e=`echo $2|wc -m`
if [ $e -lt 2 ];then
    echo -e "\033[42;37m $str\033[0m"
elif [ $2 == 0 ];then
    echo -e "\033[41;37m $str\033[0m"
else
    echo -e "\033[42;37m $str\033[0m"
fi
