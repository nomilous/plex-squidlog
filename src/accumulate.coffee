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
handler   = undefined


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

            send 'event:accumulator:register', 

                hostname: (require 'os').hostname()
                id: process.pid


        receive 'event:accumulator:instruction', (playload) -> 

            if handler

                #
                # TODO: already have a hander, uplink must 
                #       have died and recovered
                # 
                #       need to tell uplink this side is
                #       still handling what it was handling
                #       before
                #       
                #       after makin sure that's true
                #

                console.log "UPLINK RECOVERED"
                return
                

            #
            # Initialise an instruction handler with the 
            # uplink callbacks.
            # 

            handler = new (require "./#{ playload.handler }") receive, send unless handler

            #
            # Send in the instruction
            #

            handler.instruction playload.instruction

