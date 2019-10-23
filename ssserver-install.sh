#! /bin/bash
#默认密码
password=$1
password=${password:=123456}
#默认端口
port=$2
port=${port:=443}
#安装ss
yum install -y python-pip
pip install shadowsocks

#ss配置文件
echo '{
    "server":"0.0.0.0",
    "server_port":'$port',
    "local_address":"127.0.0.1",
    "local_port":1080,
    "password":"'$password'",
    "timeout":300,
    "method":"aes-256-cfb",
    "fast_open":false,
    "workers":5
}'>/etc/shadowsocks.json
#启动ss
ssserver -c /etc/shadowsocks.json -d start

#设置开机自启动
echo '[Unit]
Description=Shadowsocks
After=network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
ExecStart=/usr/bin/ssserver -c /etc/shadowsocks.json -d start
ExecStop=killall ssserver

[Install]
WantedBy=multi-user.target'>/usr/lib/systemd/system/ssserver.service
systemctl enable ssserver.service
