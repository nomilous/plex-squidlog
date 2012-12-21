module.exports = class Handler

    constructor: (@recieve, @send) -> 

        console.log "UdpServer() with:", @recieve, @send

    instruction: (parameters) -> 

        console.log "instruction: ", parameters

        