module.exports = class UdpServer

    constructor: (@recieve, @send) -> 

        console.log "UdpServer() with:", @recieve, @send

    instruction: (opts) -> 

        console.log "instruction:", opts

        #
        # Call the function named in 
        # opts.instruction
        #

        this[opts.function] opts 


    forward: (opts) ->

        console.log "call to forward with:", opts 

