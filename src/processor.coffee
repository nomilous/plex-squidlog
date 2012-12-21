#
# Tier 2 - process log stream
# 
# 
# * Listens on a local fd socket for event fowarded 
#   by the accumulator
# 

plex      = require 'plex'
uplinkUri = 'http://localhost:6001'

local = plex.start 

    mode: 'leaf'

    connect:

        #
        # Uplink to local root
        #

        adaptor: 'socket.io' 
        uri: uplinkUri


