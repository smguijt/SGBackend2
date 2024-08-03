
import Foundation
import Fluent

final class TaskManagementSettings: Model, @unchecked Sendable {
    static let schema = "TaskManagementSettings"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "key")
    var key: String
    
    @Field(key: "value")
    var value: String

    init() { }

    init(id: UUID? = nil, key: String, value: String) {
        self.id = id
        self.key = key
        self.value = value
    }
    
    func toDTO() -> TaskManagementDictDTO {
        .init(
            ID: self.id,
            key: self.key,
            value: self.value,
            userId: nil
        )
    }

}
