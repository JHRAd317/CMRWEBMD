#Persistent
SetBatchLines, -1

; Create a local HTTP listener on 127.0.0.1:8765
listener := HttpListener(8765)

; Accepting POST requests on /run
listener.OnMessage("/run", "HandleRun")

Return

HandleRun(request, response) {
    ; Read the macro payload from the request body
    payload := request.Body
    ; Sleep for 300ms before typing
    Sleep, 300
    ; Parse tokens and type
    Loop, Parse, payload, \n
        if A_LoopField == "{TAB}" 
            Send, {TAB}
        else if A_LoopField == "{ENTER}"
            Send, {ENTER}
        else if A_LoopField == "{BACKSPACE}"
            Send, {BACKSPACE}
        else if A_LoopField == "{SPACE}"
            Send, {SPACE}
        else if (InStr(A_LoopField, "{SLEEP "))
            Sleep, SubStr(A_LoopField, InStr(A_LoopField, " ") + 1, -1)
        else
            Send, % A_LoopField
    response.Send("OK")
}

HttpListener(port){
    ; Implementation of a simple HTTP listener...
    ; (omitted for brevity)
}