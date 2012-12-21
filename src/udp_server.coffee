Handler = require './handler'

module.exports = class UdpServer extends Handler

    forward: (opts) ->

        console.log "call to forward with:", opts 

