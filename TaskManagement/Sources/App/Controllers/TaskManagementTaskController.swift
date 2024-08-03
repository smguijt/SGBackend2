import Foundation
import Vapor

struct TaskManagementTaskController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let api = routes.grouped("view")
        let tasks = api.grouped("tasks")
        tasks.get(use: self.index)
    }
    
    
    @Sendable
    func index(req: Request) async throws -> View {
        
        let mySettingsDTO = try await getTaskManagementSettings(req: req)
        return try await req.view.render("index", BaseContext(title: "Task Management Service", settings: mySettingsDTO))
    }
}
