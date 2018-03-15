#!/bin/bash
#-----每次修改完密码之后自动替换掉merge中的旧密码
newpass=`cat Pass`
#----取出旧密码，并且去掉空格
if [ $user == root ];then
    cat merge.txt |grep $Host|awk -Froot '{print $2}'|awk -F-game 'NR==1{print $1}'> oldpass
    sed -i 's/[[:space:]]//g' oldpass  > /dev/null 2>&1
#---在所有的特殊符号前面加上转义 ~ ^  $  ) ( \ ] [
    sed -i 's#\~#\\~#g' oldpass  > /dev/null 2>&1
    sed -i 's#\^#\\^#g' oldpass  > /dev/null 2>&1
    sed -i 's#\$#\\$#g' oldpass  > /dev/null 2>&1
    sed -i 's#\)#\\)#g' oldpass  > /dev/null 2>&1
    sed -i 's#\(#\\(#g' oldpass  > /dev/null 2>&1
    sed -i 's#\\#\\\#g' oldpass  > /dev/null 2>&1
    sed -i 's#\]#\\]#g' oldpass  > /dev/null 2>&1
    sed -i 's#\[#\\[#g' oldpass  > /dev/null 2>&1
#-----替换密码
    old=`cat oldpass`
    echo $old
    echo $newpass
    sed -i "s#$old#$newpass#g" merge.txt   > /dev/null 2>&1
elif [ $user == game ];then
    cat merge.txt |grep $Host|awk -F-game 'NR==1{print $2}'> oldpass
    sed -i 's/[[:space:]]//g' oldpass  > /dev/null 2>&1
#---在所有的特殊符号前面加上转义 ~ ^  $  ) ( \ ] [
    sed -i 's#\~#\\~#g' oldpass  > /dev/null 2>&1
    sed -i 's#\^#\\^#g' oldpass  > /dev/null 2>&1
    sed -i 's#\$#\\$#g' oldpass  > /dev/null 2>&1
    sed -i 's#\)#\\)#g' oldpass  > /dev/null 2>&1
    sed -i 's#\(#\\(#g' oldpass  > /dev/null 2>&1
    sed -i 's#\\#\\\#g' oldpass  > /dev/null 2>&1
    sed -i 's#\]#\\]#g' oldpass  > /dev/null 2>&1
    sed -i 's#\[#\\[#g' oldpass  > /dev/null 2>&1
#-----替换密码
    old=`cat oldpass`
    echo $old
    echo $newpass
    sed -i "s#$old#$newpass#g" merge.txt   > /dev/null 2>&1
fi
exit
