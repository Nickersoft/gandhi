$ = require('jquery')
natural = require('natural')

AjaxCommentFilter = require('../AjaxCommentFilter')

class RedditFilter extends AjaxCommentFilter
    commentParentSelector: '.sitetable'
    commentThreadSelector: '.comment'
    commentSelector: '.comment'
    commentRepliesSelector: '.comment'
    commentTextSelector: '.usertext-body'

    run: =>
        $(document).ready(() =>
            chrome.runtime.sendMessage({
                type: "get_classifier"
            } , (classifier_json) =>
                classifier = natural.BayesClassifier.restore(classifier_json)
                if classifier isnt null
                    @init_listeners(classifier)
                    @filter(classifier)
            )
        )

module.exports = RedditFilter
