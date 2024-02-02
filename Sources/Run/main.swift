import App
import Vapor

extension Environment {
    static var staging: Environment {
        .custom(name: "staging")
    }
    
    static var local: Environment {
        .custom(name: "local")
    }
}

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }
try configure(app)
try app.run()
