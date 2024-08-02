import Foundation
import Vapor

struct WebSocketTaskManagementTaskMessage : Codable {
    var method: String
    var type: String
    var data: TaskManagementTaskDTO?
    var list: [TaskManagementTaskDTO]?
    
    init(method: String, type: String, data: TaskManagementTaskDTO?, list: [TaskManagementTaskDTO]? = nil) {
        self.method = method
        self.type = type
        self.data = data
        self.list = list
    }
    
    init() {
        self.method = ""
        self.type = ""
        self.data = TaskManagementTaskDTO()
        //self.list = []
    }
    
    func toBinary() -> Data? {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(self) {
            print("WebSocketTaskManagementTaskMessage.toBinary: EncodedString \(encodedData)")
            return encodedData
        }
        return nil
    }
   
}
