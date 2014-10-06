# Copyright (c) 2014 Kyoh86. All rights reserved.

# @cjsx React.DOM

Navigation = React.createClass
  render: ->
    null

TrelloCardDateLabel = React.createClass
  render: ->
    if @props.date?
      <span className="badge">{moment(@props.date).format('YY-MM-DD')}</span>
    else
      null

TrelloCard = React.createClass
  render: ->
    date = moment(@props.card.due)
    today = moment().startOf('day')
    className = "list-group-item"
    if date.isBefore(today)
      className += " list-group-item-danger"
    else if date.isSame(today)
      className += " list-group-item-warning"
    <a className={className} href={@props.card.url}>
    {@props.card.name}
    <TrelloCardDateLabel date={@props.card.due} />
    </a>

TrelloUser = React.createClass
  render: ->
    <div className="list-group">
      {
        _ @props.user.cards
        . filter (card) ->
          not card.closed
        .sortBy (card)->
          moment(card.due || '9999-12-31T23:59:59.999Z').subtract(moment())
        .map (card) ->
          <TrelloCard card={card} />
      }
    </div>

Render = ->
  Trello.members.get 'me',
    "cards": "all"
  , (member) ->
    React.renderComponent(<Navigation user=member />, jQuery("#navigation")[0])
    React.renderComponent(<TrelloUser user=member />, jQuery("#trello-cards")[0])

auth = ->
  chrome.tabs.create
    "url": chrome.extension.getURL("html/options.html")

# Run a script when the document's ready.
document.addEventListener 'DOMContentLoaded', ->
  authorize(false, Render, auth)
