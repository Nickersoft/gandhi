classifier_json = null

setBadgeText = (text, tabId) ->
    params = {text: text, tabId: tabId}
    chrome.browserAction.setBadgeText(params)

requestCount = (tabId) ->
    chrome.tabs.sendMessage(
        tabId,
        { type: "get_count" } ,
        (count) ->
            if count is undefined
                count = 0
            setBadgeText(count.toString(), tabId)
)

reparse = () ->
    chrome.tabs.query({
        active: true,
        currentWindow: true
    } , (tabs) ->
        chrome.tabs.sendMessage(
            tabs[0].id,
            { type: "reparse" } ,
            () ->
                requestCount(tabs[0].id)
    )
)

loadClassifierJSON = (callback) =>
    xmlhttp = new XMLHttpRequest()
    xmlhttp.onreadystatechange = () ->
        if xmlhttp.readyState is 4 and xmlhttp.status is 200
            classifier_json = JSON.parse(xmlhttp.responseText)
            callback(classifier_json)
    xmlhttp.open("GET", "classifier.json", true)
    xmlhttp.send()

chrome.runtime.onMessage.addListener(
    (message, sender, sendResponse) ->
        if message.type is "send_count"
            chrome.tabs.query({
                active: true,
                currentWindow: true
            } , (tabs) ->
                setBadgeText(message.count.toString(), tabs[0].id)
            )
            return
        if message.type is "get_classifier"
            if classifier_json is null
                loadClassifierJSON(sendResponse)
            else
                sendResponse(classifier_json)
            return true
        if message.type is "get_sites"
            chrome.storage.sync.get("sites_enabled", (data) ->
                site_list = {}
                if data.sites_enabled?
                    site_list = data.sites_enabled
                sendResponse(site_list)
            )
            return true
        if message.type is "set_enabled"
            if message.url? and message.enabled?
                chrome.storage.sync.get("sites_enabled", (data) ->
                    site_list = {}
                    if data.sites_enabled?
                        site_list = data.sites_enabled
                    site_list[message.url] = message.enabled
                    console.log(site_list)
                    chrome.storage.sync.set({
                        "sites_enabled": site_list
                    } )
                    sendResponse()
                )
            return true

)

chrome.tabs.onUpdated.addListener((tabId, changeInfo, tab) ->
    if changeInfo.url isnt undefined
        chrome.tabs.sendMessage(
            tabId,
            { type: "rerun" } ,
            () ->
                requestCount(tabId)
        )
)

chrome.browserAction.setBadgeBackgroundColor({
    color: "#00800B"
} )
