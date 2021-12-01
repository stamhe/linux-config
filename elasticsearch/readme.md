# ElasticSearch


### ElasticSearch 相关命令
```
curl -XGET "localhost:9200/_cat/indices?pretty"
curl -XGET "localhost:9200/_cat/health?pretty"
curl -XGET "localhost:9200/_cat/nodes?pretty"
curl -XDELETE "localhost:9200/person3"
curl -XPUT -H 'Content-Type: application/json' "localhost:9200/person3?pretty" -d '{"settings":{"number_of_shards":3,"number_of_replicas":1}}'
curl -XGET "localhost:9200/person3"
curl -XGET "localhost:9200/bank/_search?q=Virginia&pretty"
curl -XGET "localhost:9200/bank/_search?q=firstname:Virginia&sort=account_number:asc&pretty"
curl -XGET "http://localhost:9200/book_20201210/_doc/pDXJS3YBqhYaewch6KkB?pretty"
curl -XGET -H 'Content-Type: application/json' "localhost:9200/_analyze" -d '{"analyzer": "ik_smart","text": "今天天气真好"}'
curl -XGET -H "Content-Type: application/json" "localhost:9200/bank/_search?pretty" -d '{"query":{"term":{"address":"Avenue"}}}'
curl -XGET -H "Content-Type: application/json" "localhost:9200/book_20201210/_search?pretty" -d '{"query":{"terms":{"author": ["我吃西红柿", "西红柿"]}}}'
curl -XGET -H "Content-Type: application/json" "localhost:9200/bank/_search?pretty" -d '{"query":{"match":{"address":"Avenue"}}}'
curl -XPOST -H 'Content-Type: application/json' "localhost:9200/book_20201210/_search?scroll=10m&pretty" -d '{"query":{"match_all":{}},"size":3,"sort":[{"wordcount":{"order":"desc"}}]}'
curl -XPOST -H 'Content-Type: application/json' "localhost:9200/_search?pretty" -d '{"scroll_id":"","scroll":"10m"}'


服务启停相关

/usr/bin/filebeat -c /etc/filebeat/filebeatapi.yml
/usr/share/logstash/bin/logstash --path.settings /etc/logstash/ -f /etc/logstash/logstash.conf

从命令行输入测试logstash
/usr/share/logstash/bin/logstash -e 'input { stdin{} } output { file { path => "/tmp/logstash-data-%{+YYYYMMdd}.log"}}'


/usr/share/logstash/bin/logstash -e 'input { stdin{} } filter { grok { match => { "message" => "(?<datetime>\[(.*?)\])\s*(?<log_level>\[(.*?)\])\s*(?<trace_id>(.*?))\s* %{GREEDYDATA}"}  }} output { file { path => "/tmp/logstash-data-%{+YYYYMMdd}.log"}}'


/usr/share/logstash/bin/logstash -e 'input { stdin{} } filter { grok { match => { "message" => "(?<datetime>\[(.*?)\])\s*(?<log_level>\[(.*?)\])\s*(?<trace_id>(.*?))\s* %{GREEDYDATA}"}  }} output { elasticsearch { hosts => [ "192.168.1.1:9200", "192.168.1.2:9200", "192.168.1.3:9200" ] index => "stamhe-%{+YYYYMMdd}" }}'

验证 logstash 配置文件有效性
/usr/share/logstash/bin/logstash --path.settings /etc/logstash/ -f /etc/logstash/logstash.conf --config.test_and_exit



```
