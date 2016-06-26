$ = require('jquery')

StaticCommentFilter = require('../StaticCommentFilter')

class FChanFilter extends StaticCommentFilter
    commentParentSelector: '.board'
    commentThreadSelector: '.thread'
    commentSelector: '.postContainer' ## 4Chan doesn't have threads, so same as comment selector
    commentTextSelector: '.postMessage'

    removeComment: ($obj) =>
        $parent_thread = $obj.closest(@commentThreadSelector)
        if $obj.hasClass("replyContainer")
            $obj.remove()

module.exports = FChanFilter
