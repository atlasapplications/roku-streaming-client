function Init()
    ' observe "visible" so we can know when DetailsScreen change visibility
    m.top.ObserveField("visible", "OnVisibleChange")
    ' observe "itemFocused" so we can know when another item gets in focus
    m.top.ObserveField("itemFocused", "OnItemFocusedChanged")
    ' save a references to the DetailsScreen child components in the m variable
    ' so we can access them easily from other functions
    m.buttons = m.top.FindNode("buttons")
    m.poster = m.top.FindNode("poster") 
    m.description = m.top.FindNode("descriptionLabel")
    m.timeLabel = m.top.FindNode("timeLabel")
    m.titleLabel = m.top.FindNode("titleLabel")
    m.releaseLabel = m.top.FindNode("releaseLabel")
    
    ' create buttons
    result = []
    for each button in ["Play"] ' buttons list contains only "Play" button for now
        result.Push({title : button})
    end for
    m.buttons.content = ContentListToSimpleNode(result) ' set list of buttons for DetailsScreen
end function

sub OnVisibleChange() ' invoked when DetailsScreen visibility is changed
    ' set focus for buttons list when DetailsScreen become visible
    if m.top.visible = true
        m.buttons.SetFocus(true)
        m.top.itemFocused = m.top.jumpToItem
    end if
end sub

' Populate content details information
sub SetDetailsContent(content as Object)
    m.description.text = content.description ' Set description of content.
    m.poster.uri = content.hdPosterUrl ' Set url of content poster.
    m.timeLabel.text = GetTime(content.length) ' Set length of content.
    m.titleLabel.text = content.title ' Set title of content.
    m.releaseLabel.text = content.releaseDate ' Set release date of content.
end sub

sub OnJumpToItem() ' Invoked when jumpToItem field is populated.
    content = m.top.content
    ' Check if jumpToItem field has valid value.
    ' It should be set within interval from 0 to content.Getchildcount().
    if content <> invalid and m.top.jumpToItem >= 0 and content.GetChildCount() > m.top.jumpToItem
        m.top.itemFocused = m.top.jumpToItem
    end if
end sub

sub OnItemFocusedChanged(event as Object)' Invoked when another item is focused.
    focusedItem = event.GetData() ' Get position of focused item.
    content = m.top.content.GetChild(focusedItem) ' Get metadata of focused item.
    SetDetailsContent(content) ' Populate DetailsScreen with item metadata.
end sub

' The OnKeyEvent() function receives remote control key events.
function OnkeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        currentItem = m.top.itemFocused ' Position of currently focused item.
        ' Handle "left" button keypress.
        if key = "left"
            ' Navigate to the left item in case of "left" keypress.
            m.top.jumpToItem = currentItem - 1 
            result = true
        ' Handle "right" button keypress.
        else if key = "right" 
            ' Navigate to the right item in case of "right" keypress.
            m.top.jumpToItem = currentItem + 1 
            result = true
        end if
    end if
    return result
end function