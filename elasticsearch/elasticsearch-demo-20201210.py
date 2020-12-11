#!/usr/bin/python3
# pip3 install elasticsearch

from elasticsearch import Elasticsearch


# es = Elasticsearch(['127.0.0.1:9200'], http_auth=('username', 'password'))
# es = Elasticsearch(
#     ['localhost:443', 'other_host:443'],
#     # 打开SSL
#     use_ssl=True,
#     # 确保我们验证了SSL证书（默认关闭）
#     verify_certs=True,
#     # 提供CA证书的路径
#     ca_certs='/path/to/CA_certs',
#     # PEM格式的SSL客户端证书
#     client_cert='/path/to/clientcert.pem',
#     # PEM格式的SSL客户端密钥
#     client_key='/path/to/clientkey.pem'
# )



es = Elasticsearch(['127.0.0.1:9200'],
                   # 在做任何操作之前，先进行嗅探
                   sniff_on_start=True,
                   # 节点没有响应时，进行刷新，重新连接
                   sniff_on_connection_fail=True,
                   # 每 60 秒刷新一次
                   sniffer_timeout=60)

# 测试集群是否启动
print("---------------测试集群是否启动--------------------")
print(es.ping())

# 获取集群基本信息
print("---------------获取集群基本信息--------------------")
print(es.info())

# 获取集群的健康信息
print("---------------获取集群的健康信息--------------------")
print(es.cluster.health())

# 获取当前连接的集群节点信息
print("---------------获取当前连接的集群节点信息--------------------")
print(es.cluster.client.info())

# 获取集群目前的所有的索引
print("---------------获取集群目前的所有的索引--------------------")
print(es.cat.indices())

# 获取集群的更多信息
print("---------------获取集群的更多信息--------------------")
print(es.cluster.stats())

# 测试索引是否存在
print("---------------测试索引是否存在--------------------")
print(es.indices.exists("book3"))

