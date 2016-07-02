$ = require('jquery')
natural = require('natural')

FChanFilter = require('./classes/sites/4ChanFilter')
RedditFilter = require('./classes/sites/RedditFilter')
YouTubeFilter = require('./classes/sites/YouTubeFilter')

SITE_UNKNOWN = 0
SITE_YOUTUBE = "youtube.com"
SITE_4CHAN = "4chan.org"
SITE_REDDIT = "reddit.com"

filter = null

resolveSiteType = (site) ->
    if site.indexOf(SITE_YOUTUBE) >= 0
        return SITE_YOUTUBE
    if site.indexOf(SITE_4CHAN) >= 0
        return SITE_4CHAN
    if site.indexOf(SITE_REDDIT) >= 0
        return SITE_REDDIT
    return SITE_UNKNOWN

getFilter = (site) ->
    filter = null
    switch site
        when SITE_YOUTUBE then filter = new YouTubeFilter()
        when SITE_4CHAN then filter = new FChanFilter()
        when SITE_REDDIT then filter = new RedditFilter()
    return filter

site = resolveSiteType(document.location.href)
chrome.runtime.sendMessage({
    type: "get_sites"
} , (site_list) ->
    use_filter = true
    filter = getFilter(site)
    if not site_list[site] and site_list[site]?
        use_filter = false
    if use_filter and filter?
        chrome.runtime.onMessage.addListener(
            (request, sender, sendResponse) ->
                if request.type is "rerun"
                    filter.run()
                    sendResponse()
        )

        filter.run()
)
