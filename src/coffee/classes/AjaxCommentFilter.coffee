$ = require('jquery')

StaticCommentFilter = require('./StaticCommentFilter')

MutationObserver = window.MutationObserver || window.WebKitMutationObserver;

class AjaxCommentFilter extends StaticCommentFilter
    observer: null

    init_listeners: (classifier) =>
        @observer = new MutationObserver((mutations) =>
            for mutation in mutations
                if mutation.addedNodes.length isnt 0
                    @filter(classifier)
        )
        @observer.observe(
            $(@commentParentSelector).get(0),
            {
              subtree: true,
              childList: true
            }
        )

    run: =>
        MutationObserver = window.MutationObserver || window.WebKitMutationObserver;
        observer = new MutationObserver((mutations, observer) =>
            for mutation in mutations
                if $(mutation.target).is(@commentParentSelector)
                    chrome.runtime.sendMessage({
                        type: "get_classifier"
                    } , (classifier_json) =>
                        classifier = natural.BayesClassifier.restore(classifier_json)
                        if @observer isnt null
                            @observer.disconnect()
                        if classifier isnt null
                            @init_listeners(classifier)
                    )
                    observer.disconnect()
                    break

        )
        observer.observe(
            document,
            {
              subtree: true,
              attributes: true,
              childList: true,
              characterData: true
            }
        )

module.exports = AjaxCommentFilter
