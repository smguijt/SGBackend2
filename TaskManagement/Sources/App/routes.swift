import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    app.get { req async throws in
        try await req.view.render("landingpage")
    }
    
    try app.register(collection: TaskManagementTaskApiController())
    try app.register(collection: TaskManagementSettingsApiController())
}
