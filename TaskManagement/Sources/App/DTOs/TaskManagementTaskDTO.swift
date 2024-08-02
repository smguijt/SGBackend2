import Fluent
import Vapor

struct TaskManagementTaskDTO: Content {
    var id: UUID?
    var title: String?
    var description: String?
    var completed: Bool?
    var updatedAt: Date?
    var userId: UUID?
    
    func toWebSocketTaskMessage(method: String) -> WebSocketTaskManagementTaskMessage {
        .init(method: method, type: "task", data: self)
    }
    
    func toModel() -> TaskManagementTask {
        let model = TaskManagementTask()
        
        model.id = self.id
        if let title = self.title {
            model.title = title
        }
        if let description = self.description {
            model.description = description
        }
        if let completed = self.completed {
            model.completed = completed
        }
        if let updatedAt = self.updatedAt {
            model.updatedAt = updatedAt
        }
        if let userId = self.userId {
            model.userId = userId
        }
        return model
    }
}
