$ = require('jquery')

natural = require('natural')
YouTubeFilter = require('./classes/types/YouTubeFilter')

if document.location.href.indexOf("youtube.com") >= 0
    new YouTubeFilter().run()
