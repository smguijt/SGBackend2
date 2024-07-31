import NIOSSL
import Fluent
import FluentSQLiteDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(DatabaseConfigurationFactory.sqlite(.file("db.sqlite")), as: .sqlite)

    app.migrations.add(CreateTaskManagementTask())

    app.views.use(.leaf)

    // configure default port
    app.http.server.configuration.port = 5001
    
    // shutdown hook to remove all open webSocket connections
    // taken from the WebSocketConnections.swift file
    app.lifecycle.use(WebSocketShutdown())
    
    // register routes
    try routes(app)
    
    // register websocket
    try webSocketRoute(app)
}
