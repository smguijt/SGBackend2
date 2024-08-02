import Fluent
import Vapor

struct TaskManagementDictDTO: Content {
    
    let key: String?
    let value: String?
    
    init(key: String?, value: String?) {
        self.key = key
        self.value = value
    }
}
