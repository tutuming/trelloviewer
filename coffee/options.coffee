# Copyright (c) 2014 Kyoh86. All rights reserved.

# @cjsx React.DOM
TrelloCard = React.createClass
  render: ->
    <li><a href={@props.card.url}>{@props.card.name}</a></li>

TrelloUser = React.createClass
  render: ->
    <div className="trello-card">
      <h2>{@props.user.fullName} の カード一覧</h2>
      <ul>
        {<TrelloCard card={card} /> for card in @props.user.cards}
      </ul>
    </div>

Render = ->
  Trello.members.get 'me',
    "cards": "all"
  , (member) ->
    React.renderComponent(<TrelloUser user=member />, jQuery("#trello-cards")[0])
    console.log(member)

# Run a script when the document's ready.
document.addEventListener 'DOMContentLoaded', ->
  Trello.authorize
    interactive: false
    success: ->
      Render()
    failure: ->
      Trello.authorize
        name: "Trello Viewer"
        interactive: true
        expiration: "never"
        success: ->
          Render()
        failure: ->
