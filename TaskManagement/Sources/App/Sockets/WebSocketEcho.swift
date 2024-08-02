import Foundation
import Vapor

func webSocketEcho(_ app: Application, _ socketName: String = "echo") {
    
    //add ws as prefix for websockets
    let socketName1 = "ws" + socketName
    
    app.webSocket("\(socketName1)") { req, ws in
        print("WebSocket -> \(socketName1): connected")
        
        // add connection to the connection manager
        // taken from the WebSocketConnections.swift file
        app.webSocketConnections.add(ws)
        
        ws.onText { ws, text in
            print("WebSocket \(socketName1) -> Ontvangen bericht -> \(text)")
            ws.send("SGBackend2.\(socketName1): Ok.") // send return message
        }
        
        ws.onBinary { ws, data in
            print("WebSocket \(socketName1) -> Ontvangen binaire data -> \(data)")
            //ws.send(data) // send return message
            ws.send("SGBackend2.\(socketName1): Ok.")
        }
        
        ws.onClose.whenComplete { result in
            print("WebSocket \(socketName1) -> verbinding gesloten -> \(result).")
        }
    }
}

