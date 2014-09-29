class TrelloClient
  _getAuthOpts = (interactive) ->
    type: "redirect"
    name: "Trello Viewer"
    persist: true
    interactive: interactive
    scope:
      read: true
      write: false
      account: false
    expiration: "never"

  checkAuth: (handler) ->
    chrome.storage.sync.get 'trello-token', (obj) ->
      handler.call(obj['trello-token'])

  loginAuth: (handler) ->
    opts = _getAuthOpts(true)
    opts.success = ->
      token = Trello.authorize(_getAuthOpts(false))
      chrome.storage.sync.set
        'trello-token': token
      , ->
        handler.call(token)
    Trello.authorize(opts)

  getCards: (success, failure) ->
    Trello.members.get "me",
      "cards": "all"
    , success, failure
