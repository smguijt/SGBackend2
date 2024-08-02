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
            
            // Process incoming binary messages...
            guard let incomingMessage = try? JSONDecoder().decode(TaskManagementTaskSocket.self, from: data) else {
                return ws.send("SGBackend2.\(socketName1): unacceptableData")
            }
            
            print("WebSocket \(socketName1) ->  converted binary data: \(incomingMessage)")
            switch incomingMessage.method {
                case "create":
                    print("WebSocket \(socketName1) ->  create method!")
                break;
                case "delete":
                    print("WebSocket \(socketName1) ->  delete method!")
                break;
                case "patch":
                    app.logger.info("WebSocket \(socketName1) ->  patch method!")
                    let paramTaskId = incomingMessage.data.id
                    app.logger.info(" -- WebSocket \(socketName1) ->  parameter: \(String(describing: paramTaskId?.uuidString))")
                    
                    // calling sendable request (async) within a non sendable environment using Task
                    Task {
                        guard let task = try await TaskManagementTask.find(paramTaskId, on: app.db) else {
                            app.logger.error(" -- WebSocket \(socketName1) ->  Record not found for given Id!")
                            return try await ws.send("SGBackend2.\(socketName1): NoK. \(incomingMessage.method) -> Record not found for given Id!")
                        }
                        
                        app.logger.info(" -- WebSocket \(socketName1) -> Patching record...")
                        let postedTask = incomingMessage.data
                        if postedTask.title != nil {
                            task.title = postedTask.title
                        }
                        if postedTask.description != nil {
                            task.description = postedTask.description
                        }
                        if postedTask.completed != nil {
                            task.completed = postedTask.completed
                        }
                        if postedTask.updatedAt != nil {
                            task.updatedAt = postedTask.updatedAt
                        } else {
                            task.updatedAt = Date()
                        }
                        if postedTask.userId != nil {
                           task.userId = postedTask.userId
                        }
                        
                        app.logger.info(" -- WebSocket \(socketName1) -> save changes...")
                        try await task.save(on: req.db)
                        
                        try await ws.send("SGBackend2.\(socketName1): oK. \(incomingMessage.method) -> Record updated")
                    }
                
                break;
            default:
                print("WebSocket \(socketName1) ->  unsupported method!")
            }

            ws.send("SGBackend2.\(socketName1): Incomming request received. \(incomingMessage.method)")
        }
        
        ws.onClose.whenComplete { result in
            print("WebSocket \(socketName1) -> verbinding gesloten -> \(result).")
        }
    }
}
