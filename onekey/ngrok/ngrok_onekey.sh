#!/usr/bin/env bash
#2018-3-26
#一键搭建ngrok穿透服务  whisshe
#####varibale
sysInfo=`uname -m|grep x86_64|wc -l`  #为1则是64位系统
goInfo=`go version|grep "go version"|wc -l`
goV=1.8.4
#####varibale

#####functions
goVersion(){
    go version|awk '{print $3}'|awk -Fgo '{print $2}'
}
goVerify(){
    goverify=`echo $goVersion $goV |awk '{if ($1 > $2){print yes}}'`
}
go-32-install(){
    tar zxvf code/go1.8.4.linux-386.tar.gz -C /usr/local/
    ln -s /usr/local/go/bin/* /usr/bin/
}
go-64-install(){
    tar zxvf code/go1.8.4.linux-amd64.tar.gz -C /usr/local/
    ln -s /usr/local/go/bin/* /usr/bin/
}
go-install(){
    if [ $goInfo -eq 1 ];then
        goVersion
        goVerify
        if [[ $goverify != yes ]];then
            [ $sysInfo == 1 ] || go-32-install
            go-64-install
        fi
}
ngrok-server-install(){
    tar zxvf code/ngrok.tar.gz -C /usr/local/
    cd /usr/local/ngrok
    echo "输入你的服务根域名"
    read domain
#### 配置证书信息，以生成专属的客户端
    NGROK_DOMAIN="$domain"
    openssl genrsa -out base.key 2048
    openssl req -new -x509 -nodes -key base.key -days 10000 -subj "/CN=$NGROK_DOMAIN" -out base.pem
    openssl genrsa -out server.key 2048
    openssl req -new -key server.key -subj "/CN=$NGROK_DOMAIN" -out server.csr
    openssl x509 -req -in server.csr -CA base.pem -CAkey base.key -CAcreateserial -days 10000 -out server.crt
    cp base.pem assets/client/tls/ngrokroot.crt
####生成服务器和客户端
    make release-server release-client
    cp bin/ngrokd /usr/bin/
####启动服务端
    nohup ngrokd -tlsKey=server.key -tlsCrt=server.crt -domain="$domain" -httpAddr=":80"&
}

#####functions

