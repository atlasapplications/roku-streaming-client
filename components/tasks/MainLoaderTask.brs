' Note that we need to import this file in MainLoaderTask.xml using relative path.
sub Init()
    ' Set the name of the function in the Task node component to be executed when the state field changes to RUN.
    ' In our case this method executed after the following cmd: m.contentTask.control = "run"(see Init method in MainScene).
    m.top.functionName = "GetContent"
end sub

sub GetContent()
    ' Instead of retrieving data from API, set up local JSON data
    ' for testing. But kept here for a potential test server.

    ' Request the content feed from the API.
    'xfer = CreateObject("roURLTransfer")
    'xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    'xfer.SetURL("")
    'rsp = xfer.GetToString()

    CHANNEL_DATA_PATH = "pkg:/source/data/channel_data.json"
    channel_data_file = ReadAsciiFile(CHANNEL_DATA_PATH)

    if channel_data_file = ""
        print "MainLoaderTask>GetContent>couldn't find data from channel_data.json."
        return
    end if

    rootChildren = []
    rows = {}

    ' Parse the feed and build a tree of ContentNodes to populate the GridView.
    json = ParseJson(channel_data_file)

    if json = invalid
        print "MainLoaderTask>GetContent>couldn't parse JSON."
        return
    end if

    providerName = json.Lookup("providerName")

    for each category in json
        ParseChannelData(json, category, rootChildren)
    end for

    ' Set up a root ContentNode to represent rowList on the GridScreen.
    contentNode = CreateObject("roSGNode", "ContentNode")
    
    ' Update the node's data with an associative array (hash map/dictionary).
    contentNode.Update({ providerName: providerName, 
        children: rootChildren}, true) ' True indicates that it forces it to be updated on the render thread instead of the default task thread (false).

    ' Populate content field with root content node.
    ' Observer(see OnMainContentLoaded in MainScene.brs) is invoked at that moment.
    m.top.content = contentNode

end sub

sub ParseChannelData(json, category, rootChildren)
    value = json.Lookup(category)

    if Type(value) <> "roArray" ' If parsed key value having other objects in it.
        'print "MainLoaderTask>ParseChannelData>doesn't contain JSON array."
        return
    end if

    row = {}
    row.title = category
    row.children = []

    for each item in value ' Parse items and push them to row.
        itemData = GetItemData(item)
        row.children.Push(itemData)
    end for

    rootChildren.Push(row)
    
end sub

function GetItemData(video as Object) as Object
    item = {}
    ' Populate some standard content metadata fields to be displayed on the GridScreen.
    if video.longDescription <> invalid
        item.description = video.longDescription
    else
        item.description = video.shortDescription
    end if
    item.hdPosterURL = video.thumbnail
    item.title = video.title
    item.releaseDate = video.releaseDate
    item.id = video.id
    if video.content <> invalid
        ' Populate length of content to be displayed on the GridScreen.
        item.length = video.content.duration
        ' Populate meta-data for playback.
        item.url = video.content.videos[0].url
        item.streamFormat = video.content.videos[0].videoType
    end if
    return item
end function