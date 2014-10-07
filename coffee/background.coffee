updateBadge = ->
  Trello.members.get 'me',
    "cards": "all"
  , (member) ->
    newCard = []
    count = _.countBy member?.cards, (card) ->
      if card.closed
        'closed'
      else
        due = moment(card.due)
        today = moment().startOf('day')
        if localStorage["suppressedLists:"+card.idList] == "true"
          'suppressed'
        else
          # 未通知のカードを見つけたら登録する
          if localStorage["notifiedCard:"+card.id] != "true"
            newCard.push card
            localStorage["notifiedCard:"+card.id] = true

          if !card.due?
            'nodue'
          else if due.isAfter(today)
            'future'
          else
            'due'

    chrome.browserAction.setBadgeText({text: String(count.due||0)})
    if newCard.length > 1
      chrome.notifications.creat newCard[0].id,
        type: 'list'
        iconUrl: '../icon/notify_icon.png'
        title: "新着カード: #{newCard.length} 件"
        message: "#{newCard.length} 件のカードが追加されました。"
        items: _.map(newCard, (card)->
          {title: card.name, message: card.desc})
      , (id) ->

    else if newCard.length == 1
      chrome.notifications.create newCard[0].id,
        type: 'basic'
        iconUrl: '../icon/notify_icon.png'
        title: "新着カード: #{newCard[0].name}"
        message: newCard[0].desc || newCard[0].name
      , (id) ->

resetBadge = ->
  chrome.browserAction.setBadgeText({text: "?"})

pollInterval = 1000 * 60 # 1 minute
startRequest = ->
  updateBadge()
  window.setTimeout startRequest, pollInterval

document.addEventListener 'DOMContentLoaded', ->
  authorize(false, startRequest, resetBadge)
