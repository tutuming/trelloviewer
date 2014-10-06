authorize = (autoLogin, success, error) ->
  Trello.authorize
    interactive: false
    success: ->
      success()
    error: ->
      if autoLogin
        Trello.authorize
          name: "Trello Viewer"
          interactive: true
          expiration: "never"
          success: ->
            success()
          error: ->
            if error?
              error()
      else if error?
        error()
