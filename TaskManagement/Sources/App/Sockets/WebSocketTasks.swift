import Foundation
import Vapor



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
            guard let incomingMessage = try? JSONDecoder().decode(WebSocketTaskManagementTaskMessage.self, from: data) else {
                return ws.send("SGBackend2.\(socketName1): unacceptableData")
            }
            
            print("WebSocket \(socketName1) ->  converted binary data: \(incomingMessage)")
            switch incomingMessage.method {
                
            case "list":
                print("WebSocket \(socketName1) ->  list method!")
                Task {
                    let list = try await TaskManagementTask.query(on: app.db).all().map { $0.toDTO()}
                    let retList = WebSocketTaskManagementTaskMessage(method: "list", type: "task", data: nil, list: list).toBinary()
                    ws.send(retList!)
                }
                break;
                
            case "create":
                print("WebSocket \(socketName1) ->  create method!")
                Task {
                    let postedTask = incomingMessage.data!.toModel()
                    postedTask.createdAt = Date()
                    postedTask.updatedAt = Date()
                    
                    app.logger.info(" -- WebSocket \(socketName1) -> save changes...")
                    try await postedTask.save(on: req.db)
                    try await ws.send("SGBackend2.\(socketName1): oK. \(incomingMessage.method) -> Record added!")
                }
            break;
                
            case "delete":
                print("WebSocket \(socketName1) ->  delete method!")
                let paramTaskId = incomingMessage.data?.id
                app.logger.info(" -- WebSocket \(socketName1) ->  parameter: \(String(describing: paramTaskId?.uuidString))")
                Task {
                    guard let task = try await TaskManagementTask.find(paramTaskId, on: app.db) else {
                        app.logger.error(" -- WebSocket \(socketName1) ->  Record not found for given Id!")
                        return try await ws.send("SGBackend2.\(socketName1): NoK. \(incomingMessage.method) -> Record not found for given Id!")
                    }
                    app.logger.info(" -- WebSocket \(socketName1) -> Deleting record...")
                    try await task.delete(on: req.db)
                    try await ws.send("SGBackend2.\(socketName1): oK. \(incomingMessage.method) -> Record deleted!")
                }
            break;
                
            case "patch":
                app.logger.info("WebSocket \(socketName1) ->  patch method!")
                let paramTaskId = incomingMessage.data?.id
                app.logger.info(" -- WebSocket \(socketName1) ->  parameter: \(String(describing: paramTaskId?.uuidString))")
                
                // calling sendable request (async) within a non sendable environment using Task
                Task {
                    guard let task = try await TaskManagementTask.find(paramTaskId, on: app.db) else {
                        app.logger.error(" -- WebSocket \(socketName1) ->  Record not found for given Id!")
                        return try await ws.send("SGBackend2.\(socketName1): NoK. \(incomingMessage.method) -> Record not found for given Id!")
                    }
                    
                    app.logger.info(" -- WebSocket \(socketName1) -> Patching record...")
                    let postedTask = incomingMessage.data
                    if postedTask?.title != nil {
                        task.title = postedTask?.title
                    }
                    if postedTask?.description != nil {
                        task.description = postedTask?.description
                    }
                    if postedTask?.completed != nil {
                        task.completed = postedTask?.completed
                    }
                    if postedTask?.updatedAt != nil {
                        task.updatedAt = postedTask?.updatedAt
                    } else {
                        task.updatedAt = Date()
                    }
                    if postedTask?.userId != nil {
                       task.userId = postedTask?.userId
                    }
                    if postedTask?.dueDate != nil {
                       task.dueDate = postedTask?.dueDate
                    }
                    
                    app.logger.info(" -- WebSocket \(socketName1) -> save changes...")
                    try await task.save(on: req.db)
                    
                    try await ws.send("SGBackend2.\(socketName1): oK. \(incomingMessage.method) -> Record updated!")
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
