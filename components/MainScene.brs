' Entry point of  MainScene.
' Note that we need to import this file in MainScene.xml using relative path.
sub Init()
    ' Set background color for scene. Applied only if backgroundUri has empty value.
    m.top.backgroundColor = "0x662D91"
    m.top.backgroundUri= "pkg:/images/ChannelBackground.png"

    m.loadingIndicator = m.top.FindNode("loadingIndicator") ' Store loadingIndicator node to a member variable.
    m.titleLabel = m.top.FindNode("titleLabel") 

    InitScreenStack()
    ShowGridScreen()
    RunContentTask() ' Retrieving content.
end sub

' The OnKeyEvent() function receives remote control key events.
function OnkeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        ' Handle "back" key press.
        if key = "back"
            numberOfScreens = m.screenStack.Count()
            ' Close top screen if there are two or more screens in the screen stack.
            if numberOfScreens > 1
                CloseScreen(invalid)
                result = true
            end if
        end if
    end if
    ' The OnKeyEvent() function must return true if the component handled the event,
    ' or false if it did not handle the event.
    return result
end function
