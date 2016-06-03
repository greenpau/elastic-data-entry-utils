# elastic-data-entry

Elastic Search Data Entry and Pre-Processing Toolkit.

## Usage

The output of a sample log file is piped to `esde` script. 
By default, the script checks whether regular expressions in
the supplied schema file adequately cover all entries in the
supplied log file.

```
cat logs/brocade_session.log | ./esde --index-prefix="brocade-" --index-schema=matchers/brocade_session.json
```

The script could make use of non-log data using `--data` option.
Here, the script will look for `.json` files in `data` directory.

```
cat logs/brocade_session.log | ./esde --index-prefix="brocade-" --index-schema=matchers/brocade_session.json --data "data/*.json" --show-failure
```

Additionally, a user may use `--failure-line-limit` argument. When used, it causes the script to exit
once the number of lines not matching any pattern exceeds a certain threshold.

```
zcat /var/logs/cisco*.gz | ./esde --index-prefix="syslog-" --index-schema=matchers/cisco_syslog.json --show-failure --failure-line-limit 1000
```


A user may specify multiple data paths, e.g. `--data "data1/*.json" --data "data2/*.json"`.

The above command uses `--show-failure` option. When used, the data will not be loaded to elasticsearch.

```
cat logs/brocade_session.log | ./esde --index-prefix="brocade-" --index-schema=matchers/brocade_session.json --data "data/*.json" --upload
```

Unlike the `--show-failure` option, the `--upload` option causes the script to load data to elasticsearch via its Bulk API calls.


Kibana image: `:5601/bundles/src/ui/public/images/kibana.svg`

## Docker Support

The following sequence of command allows accessing `elastic-data-entry` container:

```
git clone https://github.com/greenpau/elastic-data-entry.git && cd elastic-data-entry
docker build --rm=true --force-rm=true -t greenpau/elastic-data-entry - < docker/Dockerfile
docker run -d -i -t --net=host --name=elastic-data-entry --volume=/home/greenpau/data:/tmp/data --volume=/var/log:/tmp/log  greenpau/elastic-data-entry
docker exec -it elastic-data-entry /bin/sh
```

Then, the logs previously mapped with `--volume` are available:

```
zcat /tmp/log/messages.0.gz | esde --index-prefix="syslog-" --index-schema=matchers/*.json --data=/tmp/data/*.json --upload --line-limit 2000
```
