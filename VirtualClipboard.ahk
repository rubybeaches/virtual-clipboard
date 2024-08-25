;*********************************************************************
; TITLE:   VirtualClipboard.ahk
; PURPOSE: Creates a skeuomorphic virtual clipboard for storing saved text clippings
; TRIGGER: In main script, use "Run, VirtualClipboard.ahk"
; AUTHOR:  Patrik McLain
; REVISION HISTORY:
;  *plm 12/2018 - created
;  *plm 8/2024 - made a few modifications for v2 behavior
;*********************************************************************

; TO BEGIN: 
; This script requres you to set the directory that the script is located, this location must also contain the Assets folder
SetWorkingDir, 'F:\personal\pmclain\AutoHotkey\VirtualClipboard'
; You computers zoom display effects some settings, if your display is set to 125% then you would set this value to 125
zoomLevel := 100

; BELOW THIS LINE IS CLIPBOARD FUNCTIONALITY
;*********************************************************************
#SingleInstance, Force
CustomColor = EEAA99

Gui, -Caption +LastFound +AlwaysOnTop +ToolWindow
Gui, Add, ListView, -Hdr -E0x200 AltSubmit x40 y100 w280 h300 gListAction, Coudln't Add Item

; Create an ImageList to hold icons.
ImageListID := IL_Create(1, 1)
; Assign the above ImageList to the current ListView. 
LV_SetImageList(ImageListID)  
IL_Add(ImageListID, "Assets\delete.png", 1) 

Gui, Add, Edit, vCopyEdit w275 y495 x20

Gui, Add, Picture, y475 x20 w175 h13, Assets\Label.png
Gui, Add, Picture, x335 y20 w25 h25 gGClose vExitIcon, Assets\exit.png
Gui, Add, Picture, x308 y475 w34 h42 gAddList vAddIcon, Assets\add.png

; To use a picture as a background for other controls, the picture should normally be added prior to those controls. However, if those controls are input-capable and the picture has a g-label, create the picture after the other controls and include 0x4000000 (which is WS_CLIPSIBLINGS) in the picture's Options. 
; This trick also allows a picture to be the background behind a Tab control or ListView.
Gui, Add, Picture, x0 y0 w360 h530 gUImove 0x4000000, Assets\Clipboard.png

; Set Gui color to custom color then make that color transparent
Gui, Color, %CustomColor%
WinSet, TransColor, %CustomColor%
Gui, Show, w360 h530

; Call hover function
OnMessage(0x200, "WM_MOUSEMOVE")

; Load default text to list 
Gosub, ListDef
Return

; Override Ctrl + C so we can use it for the script. The $ is needed so we can use Ctrl + C with Send
$^c::
clipboard =
Send, ^c
ClipWait
clipboardSave = %clipboard%
GuiControl, Text, CopyEdit, %clipboardSave%
Gosub, AddList
clipboard = %clipboardSave%
clipboardSave =
Return

; Override Ctrl + X so we can use it for the script. The $ is needed so we can use Ctrl + X with Send
$^x::
clipboard =
Send, ^x
ClipWait
clipboardSave = %clipboard%
GuiControl, Text, CopyEdit, %clipboardSave%
Gosub, AddList
clipboard = %clipboardSave%
clipboardSave =
Return

ListDef:
LV_Add("Icon" 2, "Select me to save this text to your clipboard!")
Return

ListAction:
; When one of the list options is selected with a left mouse click
tx1:=60 * zoomLevel / 100
If (A_GuiEvent = "Normal") {
	MouseGetPos,x,y
	If (x<tx1) {
		Rownumber := LV_GetNext(1, "F")
		LV_Delete(Rownumber)
	} Else {
		LV_GetText(copiedText, A_EventInfo)
		clipboard = %copiedText%
		copiedText =
	}
}
Return

; Allows the gui to moved with the cursor
UImove:
PostMessage, 0xA1, 2,,, A
Return

; Adds text from the edit box to the virtual clipboard list
AddList:
Gui, Submit, NoHide
If (CopyEdit = "") {
	; Set tool tip for null entries
	ToolTip, Enter text into the edit field to add to the clipboard
	SetTimer, RemoveToolTip, -5000
} Else {
	LV_Add("Icon" 1,CopyEdit)
	GuiControl, Text, CopyEdit,
}
Return

; Sets tooltip to null after 5 seconds. Had some sticking issues with the +AlwaysOnTop feature
RemoveToolTip:
ToolTip
return

; Function to handle moseover
WM_MOUSEMOVE() {
    static CurrControl, PrevControl
    CurrControl := A_GuiControl
	; Add images
    AddButton_hover:= "Assets\add_hover.png"
    AddButton_out:= "Assets\add.png"
	; Exit images
	ExitButton_hover:= "Assets\exit_hover.png"
    ExitButton_out:= "Assets\exit.png"
	
    If (CurrControl <> PrevControl and not InStr(CurrControl, " "))
    {
        If (PrevControl="AddIcon")
            GuiControl,, AddIcon, %AddButton_out%
		If (PrevControl="ExitIcon")
            GuiControl,, ExitIcon, %ExitButton_out%
        PrevControl := CurrControl
        If (CurrControl="AddIcon")
            GuiControl,, AddIcon, %AddButton_hover%
		If (CurrControl="ExitIcon")
            GuiControl,, ExitIcon, %ExitButton_hover%
    }
    Return
}

; When you press Escape or click on the x to close the window
GuiEscape:
GClose:
GuiClose:
Gui, Cancel 
Gui, Destroy 
ExitApp 