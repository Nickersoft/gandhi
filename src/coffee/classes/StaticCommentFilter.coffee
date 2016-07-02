$ = require('jquery')
natural = require('natural')

class StaticCommentFilter
    commentParentSelector: ''
    commentThreadSelector: ''
    commentSelector: ''
    commentTextSelector: ''
    count: 0

    constructor: () ->

    removeComment: ($obj) =>
        $parent_thread = $obj.closest(@commentThreadSelector)
        $parent_replies = $obj.parents(@commentRepliesSelector)
        if $parent_replies.length > 0
            $obj.remove()
        else
            $parent_thread.remove() ;

    filter: (classifier) =>
        if classifier isnt null and typeof(classifier) isnt undefined
            self = @
            $(@commentParentSelector).find(@commentSelector).each((index) ->
                comment = $(this).find(self.commentTextSelector).eq(0).text()
                if comment isnt undefined
                    label = classifier.classify(comment)
                    if label is 'neg'
                        self.removeComment($(this))
                        self.count++
            )
            chrome.runtime.onMessage.addListener(
                (message, sender, sendResponse) ->
                    switch message.type
                        when "get_count" then sendResponse self.count
            )
            chrome.runtime.sendMessage({
                type: "send_count",
                count: self.count
            } )
            return

    run: =>
        $(document).ready(() =>
            chrome.runtime.sendMessage({
                type: "get_classifier"
            } , (classifier_json) =>
                classifier = natural.BayesClassifier.restore(classifier_json)
                if classifier isnt null
                    @filter(classifier)
            )
        )


module.exports = StaticCommentFilter
