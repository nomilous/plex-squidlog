module.exports = class UdpServer

    constructor: (@recieve, @send) -> 

        console.log "UdpServer() with:", @recieve, @send

    instruction: (opts) -> 

        console.log "instruction:", opts


