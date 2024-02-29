# seaweedfs

# aws s3
```
https://github.com/seaweedfs/seaweedfs/wiki/AWS-CLI-with-SeaweedFS

pip install awscli
$ aws configure
$ aws configure set default.s3.signature_version s3v4
# list buckets
$ aws --endpoint-url http://localhost:8333 s3 ls
2019-01-02 01:59:25 newbucket

# list files inside the bucket
$ aws --endpoint-url http://localhost:8333 s3 ls s3://newbucket
2019-01-02 12:52:44       6804 password

# make a bucket
$ aws --endpoint-url http://localhost:8333 s3 mb s3://newbucket3
make_bucket: newbucket3

# add an object
$ aws --endpoint-url http://localhost:8333 s3 cp /etc/passwd s3://newbucket3
upload: ../../../../../etc/passwd to s3://newbucket3/passwd

# copy an object
$ aws --endpoint-url http://localhost:8333 s3 cp s3://newbucket3/passwd s3://newbucket3/passwd.txt
copy: s3://newbucket3/passwd to s3://newbucket3/passwd.txt

# remove an object
$ aws --endpoint-url http://localhost:8333 s3 rm s3://newbucket3/passwd
delete: s3://newbucket3/passwd

# remove a bucket
$ aws --endpoint-url http://localhost:8333 s3 rb s3://newbucket3
remove_bucket: newbucket3


```

# 安装部署
```

/data/app/seaweedfs/bin/weed master -mdir=/data/app/seaweedfs/meta -port=9333 -defaultReplication="001" -ip="data-seed-200-test.stamhe.com" -peers="data-seed-200-test.stamhe.com:9333,data-seed-201-test.stamhe.com:9333,data-seed-202-test.stamhe.com:9333"


/data/app/seaweedfs/bin/weed master -mdir=/data/app/seaweedfs/meta -port=9333 -defaultReplication="001" -ip="data-seed-201-test.stamhe.com" -peers="data-seed-200-test.stamhe.com:9333,data-seed-201-test.stamhe.com:9333,data-seed-202-test.stamhe.com:9333"


/data/app/seaweedfs/bin/weed master -mdir=/data/app/seaweedfs/meta -port=9333 -defaultReplication="001" -ip="data-seed-202-test.stamhe.com" -peers="data-seed-200-test.stamhe.com:9333,data-seed-201-test.stamhe.com:9333,data-seed-202-test.stamhe.com:9333"


/data/app/seaweedfs/bin/weed volume -max=0 -dir=/data/app/seaweedfs/volume -mserver="data-seed-200-test.stamhe.com:9333,data-seed-201-test.stamhe.com:9333,data-seed-202-test.stamhe.com:9333" -port=8080 -ip="data-seed-200-test.stamhe.com" -rack=rack1 -dataCenter=dc1 -index=leveldb -readBufferSizeMB=4096 -fileSizeLimitMB=256 -compactionMBps=100

/data/app/seaweedfs/bin/weed volume -max=0 -dir=/data/app/seaweedfs/volume -mserver="data-seed-200-test.stamhe.com:9333,data-seed-201-test.stamhe.com:9333,data-seed-202-test.stamhe.com:9333" -port=8080 -ip="data-seed-201-test.stamhe.com" -rack=rack1 -dataCenter=dc1 -index=leveldb -readBufferSizeMB=4096 -fileSizeLimitMB=256 -compactionMBps=100

/data/app/seaweedfs/bin/weed volume -max=0 -dir=/data/app/seaweedfs/volume -mserver="data-seed-200-test.stamhe.com:9333,data-seed-201-test.stamhe.com:9333,data-seed-202-test.stamhe.com:9333" -port=8080 -ip="data-seed-202-test.stamhe.com" -rack=rack1 -dataCenter=dc1 -index=leveldb -readBufferSizeMB=4096 -fileSizeLimitMB=256 -compactionMBps=100

/data/app/seaweedfs/bin/weed volume -max=0 -dir=/data/app/seaweedfs/volume -mserver="data-seed-200-test.stamhe.com:9333,data-seed-201-test.stamhe.com:9333,data-seed-202-test.stamhe.com:9333" -port=8080 -ip="data-seed-203-test.stamhe.com" -rack=rack1 -dataCenter=dc1 -index=leveldb -readBufferSizeMB=4096 -fileSizeLimitMB=256 -compactionMBps=100


/data/app/seaweedfs/bin/weed filer -dataCenter=dc1 -defaultReplicaPlacement="001" -ip="data-seed-203-test.stamhe.com" -port=8888 -defaultStoreDir=/data/app/seaweedfs/filer -master="data-seed-200-test.stamhe.com:9333,data-seed-201-test.stamhe.com:9333,data-seed-202-test.stamhe.com:9333" -maxMB=100


/data/app/seaweedfs/bin/weed filer -dataCenter=dc1 -defaultReplicaPlacement="001" -ip="data-seed-203-test.stamhe.com" -port=8888 -defaultStoreDir=/data/app/seaweedfs/filer -master="data-seed-200-test.stamhe.com:9333,data-seed-201-test.stamhe.com:9333,data-seed-202-test.stamhe.com:9333" -maxMB=100


/data/app/seaweedfs/bin/weed upload -dir="/data/tmp" -debug -master="data-seed-200-test.stamhe.com:9333" -include=*.txt


filer s3
/data/app/seaweedfs/bin/weed filer -s3 -s3.config=/data/hequan/s3.json -dataCenter=dc1 -defaultReplicaPlacement="001" -ip="data-seed-202-test.stamhe.com" -port=8333 -defaultStoreDir=/data/app/seaweedfs/filer -master="data-seed-200-test.stamhe.com:9333,data-seed-201-test.stamhe.com:9333,data-seed-202-test.stamhe.com:9333" -maxMB=100

/data/app/seaweedfs/bin/weed filer -s3 -s3.config=/data/hequan/s3.json -s3.port=8333 -defaultReplicaPlacement="001" -defaultStoreDir=/data/app/seaweedfs/filer -master="data-seed-200-test.stamhe.com:9333,data-seed-201-test.stamhe.com:9333,data-seed-202-test.stamhe.com:9333" -maxMB=100


/data/app/seaweedfs/bin/weed filer -s3 -s3.config=/data/hequan/s3.json -s3.port=8333 -defaultReplicaPlacement="001" -defaultStoreDir=/data/app/seaweedfs/filer -master="data-seed-200-test.stamhe.com:9333,data-seed-201-test.stamhe.com:9333,data-seed-202-test.stamhe.com:9333" -maxMB=100


/data/app/seaweedfs/bin/weed filer -s3 -s3.config=/data/hequan/s3.json -s3.port=8333 -defaultReplicaPlacement="001" -defaultStoreDir=/data/app/seaweedfs/filer -master="data-seed-200-test.stamhe.com:9333,data-seed-201-test.stamhe.com:9333,data-seed-202-test.stamhe.com:9333" -maxMB=100







```
