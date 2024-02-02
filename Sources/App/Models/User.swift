//
//  User.swift
//  
//
//  Created by Jani Pasanen on 2024-02-01.
//

import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "Users"

    @ID(custom: "id", generatedBy: .database)
    var id: Int?
    
    @Field(key: "Email")
    var email: String?
    
    @Field(key: "Password")
    var passwordHash: String?

    @Field(key: "Lastname")
    var lastname: String?
    
    @Field(key: "PhoneNumber")
    var phoneNumber: String?

    //@Field(key: "lastLoginTime")
    //var lastLoginTime: Date?

    //@Field(key: "registrationTime")
    //var registrationTime: Date

    @Timestamp(key: "CreatedAt", on: .create)
    var createdAt: Date?

    //@Timestamp(key: "UpdatedAt", on: .update)
    //var updatedAt: Date?

    @Timestamp(key: "DeletedAt", on: .delete)
    var deletedAt: Date?
    
    @Field(key: "Type")
    var type: String
    
    @Field(key: "FirstName")
    var firstName: String?

    @Field(key: "Username")
    var username: String?

    @Field(key: "AudioEntityId")
    var audioEntityId: String?

    @Field(key: "TCAcceptedAt")
    var tCAcceptedAt: Date?
    
    @Field(key: "TCStatus")
    var tCStatus: Int?

    init() {}
    
    init(email: String? = nil, password: String? = nil, lastName: String? = nil,
         phoneNumber: String? = nil, createdAt: Date? = nil, deletedAt: Date? = nil,
         type: String, firstName: String?, username: String?, audioEntityId: String?, tCAcceptedAt: Date? = nil, tCStatus: Int? = nil) throws {
        self.email = email
        self.passwordHash = password
        self.lastname = lastName
        self.phoneNumber = phoneNumber
        self.createdAt = createdAt
        self.deletedAt = deletedAt
        self.type = type
        self.firstName = firstName
        self.username = username
        self.audioEntityId = audioEntityId
        self.tCAcceptedAt = tCAcceptedAt
        self.tCStatus = tCStatus
    }
    
}

//Create initializer methods

/*
extension Todos_Todo {
    init (_ todo: Todo) {
        if let todoid = todo.id {
            self.todoID = todoid.uuidString
        }
        self.completed = todo.completed
        self.title = todo.title
    }
}


extension Todo {
    convenience init (_ todo: Todos_Todo) {
        self.init(id: UUID(uuidString: todo.todoID), title: todo.title, completed: todo.completed)
    }
}
 */
