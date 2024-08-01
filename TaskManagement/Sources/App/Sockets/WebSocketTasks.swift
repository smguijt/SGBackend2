import Foundation
import Vapor

struct TaskManagementTaskSocket: Codable {
    var method: String
    var type: String
    var data: TaskManagementTaskDTO
    
    init(method: String, type: String, data: TaskManagementTaskDTO) {
        self.method = method
        self.type = type
        self.data = data
    }
    
    init() {
        self.method = ""
        self.type = ""
        self.data = TaskManagementTaskDTO()
    }
    
    func toBinary() -> Data? {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(self) {
            print("TaskManagementTaskSocket.toBinary: EncodedString \(encodedData)")
            return encodedData
        }
        return nil
    }
   
}

func webSocketTasks(_ app: Application, _ socketName: String = "tasks") {
    
    /*
     {
         "method": "create",
         "type": "task",
         "data": {
             "title": "wsTask1",
             "description": "test task"
         }
     }
     
     base64: ewogICAgIm1ldGhvZCI6ICJjcmVhdGUiLAogICAgInR5cGUiOiAidGFzayIsCiAgICAiZGF0YSI6IHsKICAgICA
     gICAidGl0bGUiOiAid3NUYXNrMSIsCiAgICAgICAgImRlc2NyaXB0aW9uIjogInRlc3QgdGFzayIKICAgIH0KfQ==
    */
    
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
            
            // Process incoming binary messages...
            guard let incomingMessage = try? JSONDecoder().decode(TaskManagementTaskSocket.self, from: data) else {
                return ws.send("SGBackend2.\(socketName): unacceptableData")
            }
            
            print("WebSocket \(socketName) ->  converted binary data: \(incomingMessage)")
            switch incomingMessage.method {
                case "create":
                    print("WebSocket \(socketName) ->  create method!")
                break;
                case "delete":
                    print("WebSocket \(socketName) ->  delete method!")
                break;
                case "patch":
                    print("WebSocket \(socketName) ->  patch method!")
                break;
            default:
                print("WebSocket \(socketName) ->  unsupported method!")
            }

            ws.send("SGBackend2.\(socketName): Ok. \(incomingMessage.method)")
        }
        
        ws.onClose.whenComplete { result in
            print("WebSocket \(socketName) -> verbinding gesloten -> \(result).")
        }
    }
}
