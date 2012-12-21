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
