AjaxCommentFilter = require('../AjaxCommentFilter')

class YouTubeFilter extends AjaxCommentFilter
    commentParentSelector: '#watch-discussion'
    commentThreadSelector: '.comment-thread-renderer'
    commentSelector: '.comment-renderer'
    commentRepliesSelector: '.comment-replies-renderer'
    commentTextSelector: '.comment-renderer-text-content'

module.exports = YouTubeFilter
