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
        </div>
      </nav>
    )

AccountOptions = React.createClass
  render: ->
    <div>Accounts</div>

ListItem = React.createClass
  getInitialState: ->
    {suppressed: undefined}
  clickAction: (e)->
    @state.suppressed = !@state.suppressed
    @setState(@state)
    @props.onSelect(@state.suppressed, @props.list)
  render: ->
    # 選択状態の初期値はプロパティから取得する
    if not @state.suppressed?
      @state.suppressed = @props.suppressed

    classNames = ["list-group-item"]
    if @state.suppressed
      classNames.push "list-group-item-danger"

    <a className={classNames.join(" ")} onClick=@clickAction>
      {@props.list.name}
      <span className="glyphicon glyphicon-remove pull-right"></span>
    </a>

SuppressOptions = React.createClass
  selection: (suppressed, list)->
    localStorage["suppressedLists:"+list.id] = suppressed
  render: ->
    <div className="container-fluid">
      <h2>Suppress</h2>
      <p>Tapping names of list you want to suppress it.</p>
      {
        _(@props.boards).map (board) =>
          <div className="board-box list-group col-lg-3 col-md-4 col-sm-6 col-xs-12">
            <div className="list-group-item active">{board.name}</div>
            <div className="board-box-inner">
              {_(board.lists).map (list) =>
                <ListItem board=board list=list suppressed={localStorage["suppressedLists:"+list.id] == "true"} onSelect=@selection />}
            </div>
          </div>
        .value()
      }
    </div>

FilterOptions = React.createClass
  render: ->
    <SuppressOptions boards=@props.user.boards />
# {
#   "id": "533a3b1dc076567c0c5ab622",
#   "fullName": "山田恭一朗",
#   "url": "https://trello.com/kyoh86",
#   "username": "kyoh86",
#   "email": null,
#   "status": "active",
#   "boards": [
#     {
#       "id": "540578da958b9e6dd1106453",
#       "name": "Clulu-Server",
#       "desc": "",
#       "starred": true,
#       "url": "https://trello.com/b/B0EXSZDG/clulu-server",
#       "subscribed": false,
#       "lists": [
#         {
#           "id": "540578da958b9e6dd1106454",
#           "name": "To Do",
#           "closed": false,
#           "idBoard": "540578da958b9e6dd1106453",
#           "pos": 16384,
#           "subscribed": false
#         },
#         {
#           "id": "540578da958b9e6dd1106455",
#           "name": "Doing",
#           "closed": false,
#           "idBoard": "540578da958b9e6dd1106453",
#           "pos": 32768,
#           "subscribed": false
#         },

Copyright = React.createClass
  render: ->
    <div className="copyright">
      Icons made by Freepik from <a href="http://www.flaticon.com" title="Flaticon">www.flaticon.com</a>&nbsp;
      is licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0">CC BY 3.0</a>
    </div>

Options = React.createClass
  render: ->
    return <FilterOptions user=@props.user />

Render = ->
  Trello.members.get 'me',
    "organization_fields": "none"
    "fields": "fullName,url,username"
    "boards": "members,open"
    "board_lists": "open"
    "board_fields": "name,desc,starred,url,subscribed"
    # "lists": "open"
  , (member) ->
    React.renderComponent(<Navigation />, jQuery("#navigation")[0])
    React.renderComponent(<Options user=member />, jQuery("#options")[0])
    React.renderComponent(<Copyright />, jQuery("#copyright")[0])


# Run a script when the document's ready.
document.addEventListener 'DOMContentLoaded', ->
  authorize(true, Render, null)
