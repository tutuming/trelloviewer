# Copyright (c) 2014 Kyoh86. All rights reserved.

# @cjsx React.DOM

# Run a script when the document's ready.
document.addEventListener 'DOMContentLoaded', ->
  chrome.tabs.create
    "url": chrome.extension.getURL("html/options.html")
  return
  Trello.authorize
    interactive: false
    success: ->
      Trello.members.get 'me',
        "cards": "all"
      , (member) ->
        console.log(member)
    failure: ->
      chrome.tabs.create
        "url": chrome.extension.getURL("html/options.html")
