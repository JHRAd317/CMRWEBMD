#Requires AutoHotkey v2

; Set the listening address and port
Run, "C:\Path\To\AutoHotkey\autohotkey.exe" "107.0.0.1:8765" ; Replace with actual listening command if needed

WS := WebSocket("ws://127.0.0.1:8765")

; Handling incoming connections
WS.On("connection", { ; connection handler
    onMessage(WS)
})

; Function to handle incoming messages
onMessage(ws) {
    ws.On("message", (msg) => {
        parsed := JSON.Parse(msg);
        RunMacro(parsed);
    });
}

RunMacro(macro) {
    if (macro.Command == "run") {
        this.handleCommands(macro.Commands);
    }
}

handleCommands(commands) {
    for each, command in commands {
        if (command.Type == "SLEEP") {
            Sleep(command.Value);
        } else {
            Send(command.Value);
        }
    }
}