plex-squidlog
=============

farm an aggregated squidlog stream

Tier1
-----

one thread

* consumes the udp stream
* zero processing
* balanced redirect to local array of workers each listening on fd (unix socket)

