import Fluent
import Vapor

//If app.servers.use(.gRPCServer) is defined in the configure.swift file these routes are not reachable, only the Providers using gRPC that are registered with GRPCServer in GRPCServer.swift, for example TodoProvider.swift
func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    // try app.register(collection: TodoController())
}
