# Logs

The below command instructs operating system of `log-server` to search for the files
whose names begin with the word `brocade` inside `/var/log` directory. Once found,
it will copy the files to `/tmp/log` directory and change ownership of the files.

```
find /var/log/ -name 'brocade*' -type f -print0 | xargs -i -0 -n1 bash -c 'echo "copying" {} "to" /tmp/logs/$(basename {}) && \
    cp {} /tmp/logs/$(basename {}) && chown greenpau:greenpau /tmp/log/$(basename {})'
```

Then, the file will be available for SCP copy:

```
scp greenpau@log-server:/tmp/logs/brocade* /var/log/
```
