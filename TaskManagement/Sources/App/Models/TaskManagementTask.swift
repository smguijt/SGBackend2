import Fluent
import struct Foundation.UUID

/// Property wrappers interact poorly with `Sendable` checking, causing a warning for the `@ID` property
/// It is recommended you write your model with sendability checking on and then suppress the warning
/// afterwards with `@unchecked Sendable`.
final class TaskManagementTask: Model, @unchecked Sendable {
    static let schema = "TaskManagementTask"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String
    
    @Field(key: "completed")
    var completed: Bool?

    init() { }

    init(id: UUID? = nil, title: String, completed: Bool? = false) {
        self.id = id
        self.title = title
        self.completed = completed ?? false
    }
    
    func toDTO() -> TaskManagementTaskDTO {
        .init(
            id: self.id,
            title: self.$title.value,
            completed: self.$completed.value ?? false
        )
    }
}
