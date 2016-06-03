.PHONY: all test upload docker-%

all: test

test:
	@cat logs/brocade_session.log | ./esde --default-index-prefix="brocade-" --index-schema=matchers/*.json --data "data/*.json" --show-success \
         --line-limit=7 \
         --field-filter "(timestamp|src_ip|src_org|dst_ip|dst_port|application|tcp_handshake_time|shortname)" | column -t -s";" -o"  |  "; echo
	@cat logs/brocade_session.log | ./esde --default-index-prefix="brocade-" --index-schema=matchers/brocade_session.json --data "data/*.json" --show-failure; echo
	@cat logs/cisco_syslog.log | ./esde --index-schema=matchers/*.json --data "data/*.json" --show-success --show-json; echo
	@cat logs/cisco_syslog.log | ./esde --index-schema=matchers/*.json --data "data/*.json" --show-failure; echo
	@cat logs/cisco_syslog.log | python3 ./esde --index-schema=matchers/*.json --data "data/*.json" --show-success; echo

upload:
	@cat logs/brocade_session.log | ./esde --default-index-prefix="brocade-" --index-schema=matchers/brocade_session.json --data "data/*.json" --upload --records-per-upload 5

docker-build:
	@docker build --rm=true --force-rm=true -t greenpau/elastic-data-entry - < docker/Dockerfile

docker-run:
	@docker run -d -i -t --net=host --name=elastic-data-entry --volume=/var/log:/tmp/log greenpau/elastic-data-entry

docker-connect:
	@docker exec -it elastic-data-entry /bin/sh
