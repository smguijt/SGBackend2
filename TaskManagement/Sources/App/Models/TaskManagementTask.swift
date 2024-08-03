import Fluent
import Foundation
import struct Foundation.UUID

/// Property wrappers interact poorly with `Sendable` checking, causing a warning for the `@ID` property
/// It is recommended you write your model with sendability checking on and then suppress the warning
/// afterwards with `@unchecked Sendable`.
final class TaskManagementTask: Model, @unchecked Sendable {
    static let schema = "TaskManagementTask"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String?
    
    @Field(key: "description")
    var description: String?
    
    @Field(key: "createdAt")
    var createdAt: Date?
    
    @Field(key: "updatedAt")
    var updatedAt: Date?
    
    @Field(key: "completed")
    var completed: Bool?
    
    @Field(key: "userId")
    var userId: UUID?
    
    @Field(key: "dueDate")
    var dueDate: Date?

    init() { }

    init(id: UUID? = nil, 
         title: String?,
         description: String?,
         completed: Bool? = false,
         userId: UUID?,
         dueDate: Date?) {
        
        self.id = id
        self.title = title
        self.description = description
        self.completed = completed ?? false
        self.createdAt = Date()
        self.updatedAt = Date()
        self.userId = userId
        self.dueDate = dueDate
        
    }
    
    func toDTO() -> TaskManagementTaskDTO {
        .init(
            id: self.id,
            title: self.$title.value as? String,
            description: self.$description.value as? String,
            completed: self.$completed.value ?? false,
            updatedAt: self.$updatedAt.value as? Date,
            userId: self.$userId.value as? UUID,
            dueDate: (self.$dueDate.value!!)
        )
    }
    
    func toWebSocketTaskMessage(method: String) -> WebSocketTaskManagementTaskMessage {
        .init(method: method, type: "task", data: self.toDTO())
    }
}
