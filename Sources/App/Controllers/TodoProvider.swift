//
//  TodoProvider.swift
//  
//
//  Created by Jani Pasanen on 2024-01-04.
//

import Foundation
import GRPC
import Vapor
import Fluent



class TodoProvider: Todos_TodoServiceProvider {
    var interceptors: Todos_TodoServiceServerInterceptorFactoryProtocol?
    
    //Add reference to Vapor
    var app: Application
    
    init(_ app: Application) {
        self.app = app
    }
    
    
    func fetchTodos(request: Todos_Empty, context: StatusOnlyCallContext) -> EventLoopFuture<Todos_TodoList> {
        //TODO: Add fetchTodos
        
        //let todos = Todo.query(on: app.db(.psql)).all().map { todos -> Todos_TodoList in //1
        let todos = Todo.query(on: app.db(.mysql)).all().map { todos -> Todos_TodoList in //1
            var listToReturn = Todos_TodoList()
            for td in todos {
                listToReturn.todos.append(Todos_Todo(td)) //2
            }
            return listToReturn
        }
        
        return todos //3
        
    }
    
    func createTodo(request: Todos_Todo, context: StatusOnlyCallContext) -> EventLoopFuture<Todos_Todo> {
        //Add createTodo
        
        let todo = Todo(request) //1
        
        //mysql
        //return todo.save(on: app.db(.psql)).map { //2
        return todo.save(on: app.db(.mysql)).map { //2
            Todos_Todo(todo) //3
        }
    }
    
    func deleteTodo(request: Todos_TodoID, context: StatusOnlyCallContext) -> EventLoopFuture<Todos_Empty> {
        //Add deleteTodo
        
        guard let uuid = UUID(uuidString: request.todoID) else { //1
            context.responseStatus.code = .invalidArgument
            return context.eventLoop.makeFailedFuture(
                GRPCStatus(code: .invalidArgument, message: "Invalid TodoID")) //2
        }
        // return Todo.find(uuid, on: app.db(.psql)).unwrap(or: Abort(.notFound))
        return Todo.find(uuid, on: app.db(.mysql)).unwrap(or: Abort(.notFound))
            .flatMap { [self] todo in //3
                // todo.delete(on: app.db(.psql))
                todo.delete(on: app.db(.mysql))
                    .transform(to: context.eventLoop.makeSucceededFuture(Todos_Empty())) //4
            }
    }
    
    func completeTodo(request: Todos_TodoID, context: StatusOnlyCallContext) -> EventLoopFuture<Todos_Todo> {
        
        guard let uuid = UUID(uuidString: request.todoID) else {
            context.responseStatus.code = .invalidArgument
            return context.eventLoop.makeFailedFuture(
                GRPCStatus(code: .invalidArgument, message: "Invalid TodoID"))
        }
        // rreturn Todo.find(uuid, on: app.db(.psql)).unwrap(or: Abort(.notFound))
        return Todo.find(uuid, on: app.db(.mysql)).unwrap(or: Abort(.notFound))
            .flatMap { [self] todo in
                todo.completed = !todo.completed
                // return todo.update(on: app.db(.psql))
                return todo.update(on: app.db(.mysql))
                    .transform(to: context.eventLoop.makeSucceededFuture(Todos_Todo(todo)))
            }
    }
}
