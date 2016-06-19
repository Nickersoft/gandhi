$ = require('jquery')
natural = require('natural')

class CommentFilter
    commentParentSelector: ''
    commentThreadSelector: ''
    commentSelector: ''
    commentTextSelector: ''
    classifier: null
    count: 0
    cache: ''

    constructor: ->

    getClassifier: (callback) =>
        $.getJSON(chrome.extension.getURL('classifier.json'), (json) =>
            @classifier = natural.BayesClassifier.restore(json)
            callback()
        )

    removeComment: ($obj) =>
        $parent_thread = $obj.closest(@commentThreadSelector)
        $parent_replies = $obj.closest(@commentRepliesSelector)
        if $parent_replies.length > 0
            $obj.remove()
        else
            $parent_thread.remove()

    filter: =>
        if @classifier isnt null and typeof(@classifier) isnt undefined
            self = @
            $(@commentParentSelector).find(@commentSelector).each((index) ->
                comment = $(this).find(self.commentTextSelector).eq(0).html()
                label = self.classifier.classify(comment)
                if label is 'neg'
                    self.removeComment($(this))
                    self.count++
            )
            chrome.runtime.onMessage.addListener(
                (message, sender, sendResponse) ->
                    switch message.type
                        when "getCount" then sendResponse self.count
                        else console.error("Unrecognized message: ", message)
            )
            chrome.runtime.sendMessage({
                type: "sendCount",
                count: self.count
            } )
            return

    init: =>
        MutationObserver = window.MutationObserver || window.WebKitMutationObserver;
        observer = new MutationObserver((mutations, observer) =>
            @filter()
        )
        observer.observe(
            $(@commentParentSelector).get(0),
            {
              subtree: true,
              attributes: true,
              childList: true,
              characterData: true
            }
        )

    run: =>
        if @classifier is null
            @getClassifier(@init)
        else
            @filter()


module.exports = CommentFilter
