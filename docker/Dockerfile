FROM alpine:latest
MAINTAINER Paul Greenberg @greenpau

RUN mkdir -p /usr/local/src && apk update && apk add --no-cache python3 vim git && \
    python3 -m ensurepip && rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && pip3 install python-dateutil && \
    rm -rf /root/.cache && cd /usr/local/src && \
    git clone https://github.com/greenpau/elastic-data-entry.git && \
    cp elastic-data-entry/esde /usr/local/bin/esde && \
    ln -s /usr/bin/python3 /usr/bin/python
WORKDIR /usr/local/src/elastic-data-entry
ENTRYPOINT ["/bin/sh"]
