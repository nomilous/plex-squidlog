plex-squidlog
=============

farm an aggregated squidlog stream

Tier1
-----

one thread

* consumes the udp stream
* zero processing
* balanced redirect to local array of workers each listening on fd (unix socket)



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
* There may already be a df_squid writing to fd at something like `/var/log/squid/...` **


```bash

    destination d_squid_processor{ udp( "host.domain" port(12345) ); };

```

### Log rule

Define/modify the `log` declaration to send to the new destination.
* The may already be one **

```bash 

# squid
log {
        source(s_all);
        filter(f_squid);
        destination(df_squid);
        destination(d_squid_processor); # ADDED THIS
};


```

###

```bash

$ /etc/init.d/syslog-ng reload
Reload system logging: syslog-ng.

```

