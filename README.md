plex-squidlog
=============

farm an aggregated squidlog stream

Tier1
-----

one thread

* consumes the udp stream
* zero processing
* balanced redirect to local array of workers each listening on fd (unix sockets)

Tier2
-----

...




Syslog Config
-------------

`/etc/syslog-ng/syslog-ng.conf` 

### Filter

Define a log filter to identify events from the squid servers. <br /> 
*This may already be there.*

```bash
    
    filter f_squid { program("squid") and facility(user); };

```

### Destination

Define a destination toward which to forward the event identified by the filter. <br /> 
*There may already be a df_squid writing to fd at something like `/var/log/squid/...` *


```bash

    destination d_squid_processor{ udp( "host.domain" port(12345) ); };

```

### Log rule

Define/modify the `log` declaration to send to the new destination. <br />
*The may already be one*

```bash 

# squid
log {
        source(s_all);
        filter(f_squid);
        destination(df_squid);
        destination(d_squid_processor); # ADDED THIS
};


```

### Hup

```bash

$ /etc/init.d/syslog-ng reload
Reload system logging: syslog-ng.

```


Init (ubuntu upstart) Config
----------------------------

### Root Init 

`/etc/init/plex-squidlog-root.conf`

* assumes 'plex' is a user in the 'daemon' group
* assumes /home/plex/squidlog is the deply target


```bash 
description "Squidlog Processor Root"

env USER=plex

env RUNTIME=/home/plex/squidlog/node_modules/.bin/coffee
env EXECUTE=/home/plex/squidlog/src/root.coffee
env OPTS=""
env LOGFILE=/home/plex/squidlog/logs/root.log
env PIDFILE=/home/plex/squidlog/pids/root.pid

start on startup
stop on shutdown

respawn

exec start-stop-daemon --start \
    --chuid $USER \
    --make-pidfile --pidfile $PIDFILE \
    --exec $RUNTIME $EXECUTE $OPTS \
    2>&1 >> $LOGFILE
```

### control

```bash 
service plex-squidlog-root start|stop|reload
```

### Accumulate Init

`/etc/init/plex-squidlog-accumulator.conf`

Is almost s/identical/thesame/g as the root service, [sed](http://en.wikipedia.org/wiki/Sed) is handy for this sort of thing

```sed
sed s/root/accumulator/g < /etc/init/plex-squidlog-root.conf > /etc/init/plex-squidlog-accumulator.conf

```


