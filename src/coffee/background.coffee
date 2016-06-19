chrome.browserAction.setBadgeBackgroundColor({
    color: "#00800B"
} )

chrome.runtime.onMessage.addListener(
    (message, sender, sendResponse) ->
        if message.type is "sendCount"
            chrome.browserAction.setBadgeText({
                text: message.count.toString()
            } )
)
