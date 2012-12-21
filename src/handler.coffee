module.exports = class Handler

    constructor: (@recieve, @send) -> 

        console.log "UdpServer() with:", @recieve, @send

    actions: (opts) -> 

        for action of opts.actions

            console.log 'action:', action

            @handle action, opts.actions[action]

    handle: (action, params) -> 

        console.log 'action:', action, params
