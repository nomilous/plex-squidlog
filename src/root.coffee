#
# Root Process
# 
# 
# pending bin/ 
# 
# Usage: root <parent_uri> <workerPort>
# 


plex       = require 'plex'
uplinkUri  = 'http://localhost:3000' # TODO: argv
workerPort = 3001                    # TODO: argv

#
# `accumulators` Stores the comms callbacks to for each
#                attached udp_server. (tier1)
# 
#

accumulators = {}



local = plex.start

    #
    # This proxies control and introspection data between the 
    # workers on this branch and the [Core]()
    #

    mode: 'proxy'


    connect:

        #
        # Uplink to [Core]()
        #

        adaptor: 'socket.io' 
        uri: uplinkUri


    listen:

        #
        # [Workers](workers.html) connect here 
        #

        adaptor: 'socket.io'
        port: workerPort


    protocol: (receive, send) -> 

        receive 'event:new:udp_server', (payload) -> 

            #
            # Handle registering udp_server
            # 
            # * Store the coms callbacks
            #

            id = payload.id # the worker pid

            accumulators[ id ] = 

                receive: receive
                send:    send




            console.log "SHOWING ACCUMULATORS:", accumulators
