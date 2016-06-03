# Templates

If necessary, delete existing indices and templates:

```
curl -s -XDELETE 'http://localhost:9200/syslog-*/?pretty'
curl -s -XDELETE 'http://localhost:9200/_template/syslog/?pretty'
curl -s -XDELETE 'http://localhost:9200/.kibana/index-pattern/syslog-*/?pretty'

curl -s -XGET 'http://localhost:9200/_cat/indices/syslog-*?v'
curl -s -XGET 'http://localhost:9200/_template/syslog/?pretty'
curl -s -XGET 'http://localhost:9200/.kibana/index-pattern/syslog-*/?pretty'
```

The below command uploads `syslog-*` dynamic template:

```
curl -s -XPOST localhost:9200/_template/syslog/?pretty --data-binary "@kibana/templates/syslog.json"
```

Then, review the newly created template:

```
curl -s -XGET localhost:9200/_template/syslog/?pretty
```

Next, create an index pattern for it:

```
curl -s -XPUT localhost:9200/.kibana/index-pattern/syslog-*/?pretty -d '{"title" : "syslog-*",  "timeFieldName": "timestamp"}'
```

Review the newly created index pattern:

```
curl -s -XGET localhost:9200/.kibana/index-pattern/syslog-*/?pretty
```

Finally, upload the data:

```
zcat /var/log/*.gz | ./esde --index-prefix="syslog-" --index-schema=matchers/cisco_syslog.json --upload --line-limit 10
```
