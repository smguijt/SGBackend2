import Foundation
import Vapor

struct TaskManagementTaskSettingsController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let api = routes.grouped("view")
        let tasks = api.grouped("settings")
        tasks.get(use: self.index)
    }
    
    
    @Sendable
    func index(req: Request) async throws -> View {
        
        let mySettingsDTO = try await getTaskManagementSettings(req: req)
        return try await req.view.render("playgroundSystemSettings", BaseContext(title: "Playground", settings: mySettingsDTO))
    }
}
