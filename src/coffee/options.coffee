chrome.runtime.sendMessage({
    type: "get_sites"
} , (site_list) ->
    optionsList = document.getElementsByTagName("li")

    for option in optionsList
        option_url = option.getAttribute("data-url")

        if site_list[option_url]?
            if site_list[option_url]
                option.classList.remove("disabled")
            else
                option.classList.add("disabled")
        else
            option.classList.remove("disabled")

        option.onclick = () ->
            option_url = this.getAttribute("data-url")
            if this.classList.contains("disabled")
                chrome.runtime.sendMessage({
                    type: "set_enabled",
                    url: option_url,
                    enabled: true
                } , () =>
                    this.classList.remove("disabled")
                )
            else
                chrome.runtime.sendMessage({
                    type: "set_enabled",
                    url: option_url,
                    enabled: false
                } , () =>
                    this.classList.add("disabled")
                )
)

document.getElementById("gandhi-icon").onclick = () ->
    window.open('http://thegandhiproject.org', '_blank')
