# Copyright (c) 2014 Kyoh86. All rights reserved.

# @cjsx React.DOM

Navigation = React.createClass
  render: ->
    null

Render = ->
  React.renderComponent(<Navigation user=member />, jQuery("#navigation")[0])

# Run a script when the document's ready.
document.addEventListener 'DOMContentLoaded', ->
  authorize(true, Render, null)
