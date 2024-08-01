import Foundation
import Vapor

func webSocketTasks(_ app: Application, _ socketName: String = "tasks") {
    
    app.webSocket("\(socketName)") { req, ws in
        print("WebSocket -> \(socketName): connected")
        
        // add connection to the connection manager
        // taken from the WebSocketConnections.swift file
        app.webSocketConnections.add(ws)
        
        ws.onText { ws, text in
            print("WebSocket \(socketName) -> Ontvangen bericht -> \(text)")
            ws.send("SGBackend2.\(socketName): Ok.") // send return message
        }
        
        ws.onBinary { ws, data in
            print("WebSocket \(socketName) -> Ontvangen binaire data -> \(data)")
            //ws.send(data) // send return message
            ws.send("SGBackend2.\(socketName): Ok.")
        }
        
        
        
        ws.onClose.whenComplete { result in
            print("WebSocket \(socketName) -> verbinding gesloten -> \(result).")
        }
    }
}
