import Fluent
import FluentMySQLDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.servers.use(.gRPCServer)
    
    var tlsConfig = TLSConfiguration.makeClientConfiguration()
    tlsConfig.certificateVerification = .none
    
    app.databases.use(.mysql(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? MySQLConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
    ), as: .mysql)

    
    //DO NOT DO ANY DB MIGRATIONS if connecting to existing database
    //app.migrations.add(CreateTodo())
    //app.migrations.add(AddTodoCompletion())

    //try app.autoMigrate().wait()

    // register routes
    // When .gRPCServer is defined by app.servers.use it will be used to handle calls and not web rpc on port 8080 so below routes are registered but not reachable.
    //try routes(app)
}
