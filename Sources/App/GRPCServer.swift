/// Copyright (c) 2022 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.


import Foundation
import Vapor
import Logging
import GRPC

public extension Application.Servers.Provider {
    static var gRPCServer: Self {
        .init {
            $0.servers.use { app in GRPCServer(application: app)
            }
        }
    }
}

public class GRPCServer: Vapor.Server {
    
    var port = 8095
    var host = "localhost"
    var application: Application
    //var server: Server?
    var server: GRPC.Server?
    
    
    init(application: Application) {
        self.application = application
    }
    
    public func start(address: BindAddress?) throws {
        
        switch address {
        case .none:
            break
        case .hostname(let hostname, let port):
            if let hostname = hostname {
                self.host = hostname
            }
            if let port = port {
                self.port = port
            }
        default:
            fatalError()
        }
        
        
        //Spin up gRPC server
        
        //set up logging
        
        //#if swift(<5.5)
        var logger = Logger(label: "grpc", factory:
                                StreamLogHandler.standardError(label:))
    
        //#elseif swift(>=5.5)
         //   var logger = Logger(label: "grpc", factory: StreamLogHandler.standardOutput) //1
        //#endif
        
        logger.logLevel = .debug

        //bind to host and port. do not use SSL
        let group = application.eventLoopGroup
        let server = GRPC.Server.insecure(group: group) //2
          .withLogger(logger)
          .withServiceProviders([TodoProvider(application)]) //3
          .bind(host: self.host, port: self.port)
          server.map { //4
            $0.channel.localAddress
          }.whenSuccess { address in
            logger.debug("gRPC Server started on port \(address!.port!)",  metadata: nil)
          }

        self.server = try server.wait() //5

        
        
    }
    
    
    public var onShutdown: EventLoopFuture<Void> {
        //return application.eventLoopGroup.future()
        return server!.channel.closeFuture
    }
    
    
    
    public func shutdown() {
        try! self.server!.close().wait()
    }
    
    
}
