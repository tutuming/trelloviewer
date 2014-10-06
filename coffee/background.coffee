updateBadge = ->
  console.log('updateBadge')
  Trello.members.get 'me',
    "cards": "all"
  , (member) ->
    count = _.countBy member?.cards, (card) ->
      if card.closed
        'closed'
      else
        due = moment(card.due)
        today = moment().startOf('day')
        if due.isBefore(today)
          'passed'
        else if due.isSame(today)
          'today'
    chrome.browserAction.setBadgeText({text: String((count.passed||0) + (count.today||0))})

resetBadge = ->
  console.log('resetBadge')
  chrome.browserAction.setBadgeText({text: "?"})

pollInterval = 1000 * 60 # 1 minute
startRequest = ->
  console.log('startRequest')
  updateBadge()
  window.setTimeout startRequest, pollInterval

document.addEventListener 'DOMContentLoaded', ->
  console.log('loaded')
  authorize(false, startRequest, resetBadge)
