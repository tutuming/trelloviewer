# Copyright (c) 2014 Kyoh86. All rights reserved.

# @cjsx React.DOM

Navigation = React.createClass
  render: ->
    return (
      <nav className="navbar navbar-default" role="navigation">
        <div className="container-fluid">
          <div className="navbar-header">
            <button type="button" className="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar-links">
              <span className="sr-only">Toggle navigation</span>
              <span className="icon-bar"></span>
              <span className="icon-bar"></span>
              <span className="icon-bar"></span>
            </button>
            <a className="navbar-brand" href="#">Mogelo</a>
          </div>

          <div className="collapse navbar-collapse" id="navbar-links">
            <ul className="nav navbar-nav navbar-right">
              <li><a href={chrome.extension.getURL("html/options.html")} target="_blank">Options</a></li>
            </ul>
          </div>
        </div>
      </nav>
    )

TrelloCardDateLabel = React.createClass
  render: ->
    className = @props.className || ""
    className += " label col-xs-3"
    if @props.date?
      <span className={className}>{moment(@props.date).format('MM/DD')} @ {moment(@props.date).format('HH:mm')}</span>
    else
      null

TrelloCard = React.createClass
  render: ->
    date = moment(@props.card.due)
    today = moment().startOf('day')
    className = "container list-group-item"
    linkClass = "label-default"
    if date.isBefore(today)
      className += " list-group-item-danger"
      linkClass = "label-danger"
    else if date.isSame(today)
      className += " list-group-item-warning"
      linkClass = "label-warning"
    <a className={className} href={@props.card.url} target="_blank">
    <span className={if @props.card.due? then "col-xs-9" else "col-xs-12"}>{@props.card.name}</span>
    <TrelloCardDateLabel date={@props.card.due} className={linkClass}/>
    </a>

TrelloUser = React.createClass
  render: ->
    <div className="list-group">
      {
        _ @props.user.cards
        . filter (card) ->
          not card.closed and (localStorage["suppressedLists:"+card.idList] != "true")
        .sortBy (card)->
          moment(card.due || '9999-12-31T23:59:59.999Z').subtract(moment())
        .map (card) ->
          <TrelloCard card={card} />
      }
    </div>

Copyright = React.createClass
  render: ->
    <div className="copyright">
      Icons made by Freepik from <a href="http://www.flaticon.com" title="Flaticon">www.flaticon.com</a>&nbsp;
      is licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0">CC BY 3.0</a>
    </div>

Render = ->
  Trello.members.get 'me',
    "cards": "all"
  , (member) ->
    React.renderComponent(<Navigation user=member />, jQuery("#navigation")[0])
    React.renderComponent(<TrelloUser user=member />, jQuery("#trello-cards")[0])
    React.renderComponent(<Copyright />, jQuery("#copyright")[0])

auth = ->
  chrome.tabs.create
    "url": chrome.extension.getURL("html/options.html")

# Run a script when the document's ready.
document.addEventListener 'DOMContentLoaded', ->
  authorize(false, Render, auth)
