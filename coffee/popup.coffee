# Copyright (c) 2014 Kyoh86. All rights reserved.

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

  onLoad: ->
    console.log "onLoad"
    if @checkAuth()
      console.log "authed"
    else
      console.log "login"
      @loginAuth()

  checkAuth: ->
    Trello.authorize(_getAuthOpts(false))

  loginAuth: ->
    chrome.tabs.create
      "url": chrome.extension.getURL("html/options.html")

# Run a script when the document's ready.
document.addEventListener 'DOMContentLoaded', ->
  console.log "Trello Viewer"
  trello = new TrelloClient()
  trello.onLoad()
