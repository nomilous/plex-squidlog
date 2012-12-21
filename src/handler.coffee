module.exports = class Handler


    constructor: (@recieve, @send) -> 


    #
    # `handler.actions()` **to call each specified action**
    # 
    # The controller (local root) may have sent a sequence
    # of actions to perform.
    #

    actions: (opts) -> 

        for action of opts.actions

            @handle action, opts.actions[action]


    #
    # `handler.handle()` **to perform an action** 
    #

    handle: (action, params) -> 

        actionFn = @getActionFn action

        if params.interval

            setInterval (-> 

                actionFn params

            ), params.interval * 1000


    #
    # `handler.getActionFn()` **to get the action**
    # 
    # This returns the action function wrapped in the
    # proper context.
    # 
    # ie. *this* is set the **this** handler
    #

    getActionFn: (action) -> 

        fn = @[action]

        return (params) => 

            fn.call this, params


    #
    # `handler.query()` **an action**
    # 
    # Sends a query to the controller. 
    # The query includes the id of this
    # handler.
    #

    query: (params) -> 

        @send 'event:query', {

            id: process.pid
            query: 'get:' + params.get

        }, -> 

            console.log "QUERY response"
