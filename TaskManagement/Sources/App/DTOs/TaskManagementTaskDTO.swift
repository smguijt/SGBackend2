import Fluent
import Vapor

struct TaskManagementTaskDTO: Content {
    var id: UUID?
    var title: String?
    var completed: Bool?
    
    func toModel() -> TaskManagementTask {
        let model = TaskManagementTask()
        
        model.id = self.id
        if let title = self.title {
            model.title = title
        }
        if let completed = self.completed {
            model.completed = completed
        }
        return model
    }
}
