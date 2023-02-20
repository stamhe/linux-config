# bitwarden
```
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

#测试一下有没有成功
sudo apt-key fingerprint 0EBFCD88
#有以下反馈就表示成功
pub   rsa4096 2017-02-22 [SCEA]
      9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
uid           [ unknown] Docker Release (CE deb) <docker@docker.com>
sub   rsa4096 2017-02-22 [S]

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

#验证一下是不是正确安装
sudo docker run hello-world

#有以下反馈就表示正确安装
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
0e03bdcc26d7: Pull complete 
Digest: sha256:4cf9c47f86df71d48364001ede3a4fcd85ae80ce02ebad74156906caff5378bc
Status: Downloaded newer image for hello-world:latest
Hello from Docker!
This message shows that your installation appears to be working correctly.
To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.
To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash
Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/
For more examples and ideas, visit:
 https://docs.docker.com/get-started/
 

# 安装 docker-compose
wget -c "https://github.com/docker/compose/releases/download/v2.14.2/docker-compose-linux-x86_64" -O /usr/local/bin/docker-compose
 
chmod a+x /usr/local/bin/docker-compose
docker-compose --version
# 安装 vaultwarden
docker pull vaultwarden/server:latest

# 环境变量
SIGNUP_ALLOWED：是否允许注册
INVITATIONS_ALLOWED：是否允许组织邀请注册
ADMIN_TOKEN：用户管理界面 (/admin)，可用于删除用户及邀请用户注册
ROCKET_TLS：ssl 证书信息，同时需要配置 -v /path/to/host/ssl/:/path/to/docker/ssl/ 卷，前者为宿主机 ssl 证书的位置，后者为容器证书位置
DOMAIN：域名
LOG_FILE、LOG_LEVEL、EXTENDED_LOGGING：日志保存文件路径以及日志等级定义
DATA_FOLDER：docker 容器数据保存文件夹（默认为 /data），除了定义这个文件夹之外，还可以定义附件、图标缓存、数据库等参数
DATABASE_URL：数据库路径
ATTACHMENT_FOLDER：附件路径
ICON_CACHE_FOLDER：图标缓存路径

# 启动 docker
docker run -d --name vaultwarden \
  -e ADMIN_TOKEN=password \
  -e SIGNUPS_ALLOWED=false \
  -e WEBSOCKET_ENABLED=true \
  -e WEB_VAULT_ENABLED=true \
  -e DOMAIN=https://bitwarden.domain.com \
  -e LOG_FILE=/data/vaultwarden.log \
  -e SMTP_HOST=smtp.mailgun.org \
  -e SMTP_FROM="StamHeVault<no-reply@stamhe.com>" \
  -e SMTP_PORT=587 \
  -e SMTP_SSL=true \
  -e SMTP_USERNAME=postmaster@domain.com \
  -e SMTP_PASSWORD=password \
  -v /data/vaultwarden/:/data/ \
  -p 8880:80 \
  -p 3012:3012 \
  vaultwarden/server:latest

# 停止
docker stop vaultwarden
# 启动
docker start vaultwarden

# 备份数据
rsync -avPtc /data/vaultwarden/ /data_back/vaultwarden/

# 恢复数据
docker stop vaultwarden
rsync -avPtc /data_back/vaultwarden/ /data/vaultwarden/
docker start vaultwarden

# ****** 升级 ******
# 重新拉取镜像
docker pull vaultwarden/server:latest

# 停止原容器
docker stop vaultwarden

# 删除原容器
docker rm vaultwarden

# 新运行
docker run

# 停止
docker stop vaultwarden

# 恢复数据
rsync -avPtc /data_back/vaultwarden/ /data/vaultwarden/

# 启动
docker start vaultwarden


```

# nginx 配置
```
# 配置 nginx
client_max_body_size 128M;
    location / {
	    proxy_pass http://127.0.0.1:8880;
	    proxy_redirect off;
	    proxy_http_version 1.1;
	    proxy_set_header Upgrade $http_upgrade;
	    proxy_set_header Connection "upgrade";
	    proxy_set_header Host $http_host;

	    proxy_connect_timeout 10;
	    proxy_read_timeout 10;
	    proxy_send_timeout 10;
	    proxy_set_header X-Real-IP $remote_addr;
	    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
    location /notifications/hub {
	    proxy_pass http://127.0.0.1:3012;
	    proxy_redirect off;
	    proxy_http_version 1.1;
	    proxy_set_header Upgrade $http_upgrade;
	    proxy_set_header Connection "upgrade";
	    proxy_set_header Host $http_host;

	    proxy_connect_timeout 10;
	    proxy_read_timeout 10;
	    proxy_send_timeout 10;
	    proxy_set_header X-Real-IP $remote_addr;
	    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
    location /notifications/hub/negotiate {
	    proxy_pass http://127.0.0.1:8880;
	    proxy_redirect off;
	    proxy_http_version 1.1;
	    proxy_set_header Upgrade $http_upgrade;
	    proxy_set_header Connection "upgrade";
	    proxy_set_header Host $http_host;

	    proxy_connect_timeout 10;
	    proxy_read_timeout 10;
	    proxy_send_timeout 10;
	    proxy_set_header X-Real-IP $remote_addr;
	    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

```


# docker-compose
```
$ cd ~ && mkdir bitwarden && cd bitwarden
$ cat > ~/bitwarden/docker-compose.yml<<EOF
version: "3"

services:
  bitwarden:
    image: vaultwarden/server
    container_name: vaultwarden
    restart: always
    ports:
        - "127.0.0.1:8087:80" #将宿主机8087端口映射到docker的80端口
        - "127.0.0.1:3012:3012"
    volumes:
      - ./bw-data:/data
    environment:
      WEBSOCKET_ENABLED: "true" #是否开启WebSocket
      SIGNUPS_ALLOWED: "true"   #是否开启注册，自用的话自己搭建好注册后改成false
      WEB_VAULT_ENABLED: "true" #是否开启Web客户端
      # ADMIN_TOKEN: "   #后台登陆密码，建议openssl rand -base64 48 生成ADMIN_TOKEN确保安全，当前是没启用，如需启用去掉ADMIN_TOKEN前面的 # ，并生成安全密码
EOF

# 启动 bitwarden
$ cd ~/bitwarden
$ docker-compose up -d // 如果报错，参考下面添加用户组
$ docker-compose down #关闭服务
$ docker-compose restart #重启服务

```

# 备份数据到 google drive
```
安装 rclone，参考文档 github
$ curl https://rclone.org/install.sh | sudo bash

设置 rclone config， 参考文档 rclone.org/drive
$ rclone config

# 将本地目录复制到云端
$ rclone copy /data/vaultwarden remote:vaultwarden



添加定时任务
# 每天凌晨两点备份一次
0 2 * * *   rclone copy ~/bitwarden/bw-data remote:bitwarden/bw-data

```

# fail2ban
```
https://rs.ppgg.in/configuration/security/fail2ban-setup
```
