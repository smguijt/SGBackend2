import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    app.get { req async throws in
        try await req.view.render("landingpage")
    }
    
    /* setup API controllers */
    try app.register(collection: TaskManagementTaskApiController())
    try app.register(collection: TaskManagementSettingsApiController())
    
    /* setup VIEW controllers */
    try app.register(collection: TaskManagementTaskController())
    try app.register(collection: TaskManagementTaskSettingsController())
}
