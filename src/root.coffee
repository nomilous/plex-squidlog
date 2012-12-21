#
# Root Process
# 
# 
# pending bin/ 
# 
# Usage: root <parent_uri> <workerPort>
# 


plex       = require 'plex'
uplinkUri  = 'http://localhost:2020' # TODO: argv
workerPort = 6001                    # TODO: argv

logStream  = 
    instruction: 'listen'
    mode: 'squidlog'
    port: 12345

#
# `accumulators` Stores the comms callbacks to for each
#                attached udp_server. (tier1)
# 
# `accumulators.id.connected_at` Set on connect
# 
# `accumulators.id.disconnected_at` Set on disconnect
# 
# TODO: - cull disconnected...
#         respawn will have new pid therefore new id
# 
#       - uptime metrix (high frequency respawns generally 
#         mean code was pushed with unforseen bug)
# 

accumulators = {}
showAccumulators = -> console.log "\n\n\nACCUMULATORS:", JSON.stringify accumulators, null, 2


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

        receive 'event:udp_server:register', (payload) -> 

            #
            # Handle registering udp_server
            # 
            # * Store the coms callbacks
            #

            id = payload.id # the worker pid

            accumulators[ id ] = 

                receive: receive
                send:    send

            accumulators[ id ].connect_at = new Date()

            #
            # tell the [Accumulator](accumulator.html) where to listen
            # 
            # Note: This currently only support one squidlog stream,
            #       starting multiple accumulators will collide with
            #       addressinuse when going to listen.
            #       
            #  

            send 'event:udp_server:instruction', logStream

            showAccumulators()


            #
            # subscribe to THIS accumulator disconnecting
            #

            receive 'disconnect', ->

                accumulators[ id ].disconnect_at = new Date()
                showAccumulators()
