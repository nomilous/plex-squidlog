#
# Tier 1 - receives a UDP log stream
# 
# 
# * Processes no data
# * [Round Robin](http://www.flickr.com/photos/josh_marvin/5617016190/) redirect to workers
# * Reports highlevel metrics to [local root](root.html)
# 
# pending bin/ 
# 
# Usage: udp_server <parent_uri> <udp_port>
# 

plex      = require 'plex'
uplinkUri = 'http://localhost:6001'
udpPort   = 12345

local = plex.start 

    mode: 'leaf'

    connect:

        #
        # Uplink to local root
        #

        adaptor: 'socket.io' 
        uri: uplinkUri



    protocol: (receive, send) -> 

        receive 'connect', -> 

            #
            # Register with local root
            #

            send 'event:new:udp_server', 

                id: process.pid
