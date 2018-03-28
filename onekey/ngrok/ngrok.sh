#!/usr/bin/env bash
##ngrok一键安装脚本
ssh-key(){
if [ !  -f ~/.ssh/id_rsa.pub ];then 
    echo -e "\033[34m输入回车以生成公钥\033[0m"; [ ! -d / ] || ssh-keygen
fi
	echo "输入远程机器的IP或者别名"
	read host
	echo -e "\033[34m根据提示输入远程机器的root密码\033[0m"
	ssh-copy-id root@$host 
	[ $? ==0 ] || echo -e "\033[31mhost or IP addr is wrong!!!\033[0m" ;exit 1
	read passwd
}
ngrok-install(){
	/usr/bin/scp  ../ngrok root@$host:/tmp/
	ssh root@$host "/tmp/ngrok-server-install.sh"
	scp root@$host:/usr/local/ngrok/bin/ngrok /usr/local/bin/
}
ngrok-cfg(){
	echo -e "\033[34m 输入外网服务器的根域名\033[0m"
	read domain
	echo -e "\033[34m 输入服务器的子域名，如 www\033[0m"
    read subdomain
    sed -i 's/$domain/domain/' ngrok.cfg
    sed -i 's/$subdomain/sub-domain/' ngrok.cfg
	echo -e "\033[34m 默认映射的ssh端口为1122，如 www\033[0m"
	echo -e "\033[34m 默认映射的http端口为80，如 www\033[0m"
	echo -e "\033[34m 通过ssh连接方法为：ssh user@$subdomain.$domain -p 1122，如 www\033[0m"
	echo -e "\033[34m 通过http访问方法为：http://$subdomain.$domain \033[0m"
 }
ngrok-start(){
	nohup ngrok -config=ngrok.cfg  start ssh http &
}
ssh-key
ngrok-install
ngrok-cfg
ngrok-start