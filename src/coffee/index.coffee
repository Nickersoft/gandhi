$ = require('jquery')
natural = require('natural')

FChanFilter = require('./classes/sites/4ChanFilter')
# YouTubeFilter = require('./classes/sites/YouTubeFilter')

SITE_UNKNOWN = 0
SITE_YOUTUBE = 1
SITE_4CHAN = 2

filter = null

resolveSiteType = (site) ->
    if site.indexOf("youtube.com") >= 0
        return SITE_YOUTUBE
    if site.indexOf("4chan.org") >= 0
        return SITE_4CHAN
    return SITE_UNKNOWN

filter = new FChanFilter()

# switch resolveSiteType(document.location.href)
#     when SITE_YOUTUBE then filter = new YouTubeFilter()
#     when SITE_4CHAN then filter = new FChanFilter()

chrome.runtime.onMessage.addListener(
    (request, sender, sendResponse) ->
        if request.type is "rerun"
            filter.run()
            sendResponse()
)

filter.run()
