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



#
# TODO: retry connect, dont let the deamon die
#

plex      = require 'plex'
uplinkUri = 'http://localhost:6001'
Handler   = require './udp_server' 


listen = (opts) -> 

    console.log "start listen:", opts 



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

            send 'event:udp_server:register', 

                hostname: (require 'os').hostname()
                id: process.pid


        receive 'event:udp_server:instruction', (instruction) -> 

            #
            # Initialise an instruction handler with the 
            # uplink callbacks.
            # 

            handler = new Handler receive, send

            #
            # Send in the instruction
            #

            handler.instruction instruction

