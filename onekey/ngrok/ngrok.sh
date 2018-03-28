#!/usr/bin/env bash
##ngrok一键安装脚本
if [ !  -f ~/.ssh/id_rsa.pub ];then 
    echo -e "\033[34m输入回车以生成公钥\033[0m"; [ ! -d / ] || ssh-keygen
fi

echo "输入远程机器的IP或者别名"
read host
echo -e "\033[34m根据提示输入远程机器的root密码\033[0m"
ssh-copy-id root@$host 
[ $? ==0 ] || echo -e "\033[31mhost or IP addr is wrong!!!\033[0m" ;exit 1
read passwd
