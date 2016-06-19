CommentFilter = require('../CommentFilter')

class YouTubeFilter extends CommentFilter
    commentParentSelector: '#watch-discussion'
    commentThreadSelector: '.comment-thread-renderer'
    commentSelector: '.comment-renderer'
    commentRepliesSelector: '.comment-replies-renderer'
    commentTextSelector: '.comment-renderer-text-content'

module.exports = YouTubeFilter
