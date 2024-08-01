import NIOSSL
import Fluent
import FluentSQLiteDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    
    app.logger.info("Enable middleware:FileMiddleware")
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.logger.info("Initialize database")
    //app.databases.use(DatabaseConfigurationFactory.sqlite(.file("db.sqlite")), as: .sqlite)
    app.databases.use(.sqlite(.memory), as: .sqlite)
    
    /* Create database objects */
    app.logger.info("Create database objects")
    app.migrations.add(CreateTaskManagementTask())

    /* auto migrate */
    app.logger.info("automigration executed")
    try await app.autoMigrate()
    
    // serve views
    app.logger.info("Enable view engine .leaf")
    app.logger.info("template dir: \(app.leaf.configuration.rootDirectory)")
    app.views.use(.leaf)
    app.leaf.tags["now"] = NowTag()

    // configure default port
    app.logger.info("Default port set to 5003 for TaskManager Service")
    app.http.server.configuration.port = 5003
    
    // shutdown hook to remove all open webSocket connections
    // taken from the WebSocketConnections.swift file
    app.lifecycle.use(WebSocketShutdown())
    
    // register routes
    try routes(app)
    
    // register websocket
    try webSocketRoute(app)
}
