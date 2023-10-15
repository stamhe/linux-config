# minio

## 软件包
```
dd if=/dev/random of=data.bin bs=1M count=50

环境变量

export MINIO_ROOT_USER='stamhe'
export MINIO_ROOT_PASSWORD='123456'
export MINIO_BROWSER_REDIRECT_URL="127.0.0.1" # 是浏览器重定向域名，若希望通过反向代理将服务暴露到公网，通过域名访问，请设置对应域名

export MINIO_ACCESS_KEY="admin"	# 过时
export MINIO_SECRET_KEY="123456" # 过时


https://dl.min.io/server/minio/release/linux-amd64/minio
https://dl.min.io/client/mc/release/linux-amd64/mc

wget "https://dl.min.io/server/minio/release/linux-amd64/minio"
wget "https://dl.min.io/client/mc/release/linux-amd64/mc"

chmod a+x mc
/bin/cp -f mc /usr/local/bin/
mc --autocompletion # 添加自动补全
添加自动补全后会在 $HOME/.mc/ 下生成一系列配置文件
ls -al ~/.mc/
certs  config.json  session  share


设置端点别名 - myminio
mc alias set 'myminio' 'http://127.0.0.1:9000' 'stamhe' '123456'

创建一个 bucket
mc mb myminio/testbucket1
  
创建文件并查看
echo "hello world" | mc pipe myminio/testbucket1/test.txt
mc ls myminio/testbucket1/
mc cat myminio/testbucket1/test.txt

查看 bucket
mc ls myminio

查看使用空间: 总的空间使用以及各个 bucket 的使用
mc du --depth=2 myminio


mc du myminio/testbucket1

拷贝文件
dd if=/dev/zero of=test_file.txt bs=1M count=100
mc cp test_file.txt myminio/testbucket1/
mc du myminio/testbucket1
100MiB	testbucket1

具体数据存储格式如下，可见数据被分散到多个节点中，每个节点中的数据又再次被分为多个part。
du data1-1/testbucket1/ -h
du data1-1/testbucket1/ --max-depth=1 -h


查看集群信息
mc admin info myminio

或者直接json形式输出
mc admin info myminio --json 

fuse使用
s3fs可以直接将minio挂载为文件系统形式，更加方便使用。

下载s3fs
apt-get install s3fs


touch ${HOME}/.passwd-s3fs
内容为： 
minio:minio123
mkdir -p /home/minio/test01
s3fs test01 /home/minio/test01 -o passwd_file=${HOME}/.passwd-s3fs -o url=http://127.0.0.1:9001/ -o use_path_request_style
该命令将bucket test01 挂载到 /home/minio/test01 目录

```

## 单机版安装
```
export MINIO_ROOT_USER='stamhe'
export MINIO_ROOT_PASSWORD='123456'
export MINIO_BROWSER_REDIRECT_URL="127.0.0.1" # 是浏览器重定向域名，若希望通过反向代理将服务暴露到公网，通过域名访问，请设置对应域名

/data/app/minio/bin/minio server --address "0.0.0.0:9191" /data/app/minio/data
```

## 集群安装
```
所有机器都加下面的 host
192.168.1.200 node200
192.168.1.201 node201
192.168.1.202 node202
192.168.1.203 node203

所有机器都配置下面的环境变量
export MINIO_ROOT_USER='stamhe'
export MINIO_ROOT_PASSWORD='123456'

所有机器都执行下面的命令启动（注意开放相互之间的访问） - 端口是 【9191】
/data/app/minio/bin/minio server --address "0.0.0.0:9191" http://node200/data/app/minio/data http://node201/data/app/minio/data http://node202/data/app/minio/data http://node203/data/app/minio/data


```

## nginx 反向代理
```

upstream minio_s3 {
   least_conn;
   server node200:9191;
   server node201:9191;
}

server {
 listen 80;
 server_name example.com;

 # 允许报文头出现特殊字符
 ignore_invalid_headers off;
 # 允许超大文件
 client_max_body_size 0;
 # 禁用代理缓冲区
 proxy_buffering off;

 location / {
   proxy_set_header X-Real-IP $remote_addr;
   proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
   proxy_set_header X-Forwarded-Proto $scheme;
   proxy_set_header Host $http_host;

   proxy_connect_timeout 300;
   # 启用HTTP1.1，使用Keeplive
   proxy_http_version 1.1;
   proxy_set_header Connection "";
   chunked_transfer_encoding off;

   proxy_pass http://minio_s3;
 }
}
```