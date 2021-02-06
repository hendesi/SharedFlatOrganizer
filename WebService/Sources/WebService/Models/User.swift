//
//  File.swift
//  
//
//  Created by Felix Desiderato on 01.02.21.
//

import Foundation
import Fluent
@testable import ApodiniDatabase
@testable import Apodini
import FluentMongoDriver

final class User: DatabaseModel {
    static var schema: String = "Users"
    
    @ID
    var id: UUID?
    @Field(key: "name")
    var name: String
    @Field(key: "picture")
    var pictureData: Data?
    @Field(key: "currentObjectives")
    var currentObjectiveIDs: [UUID]
    
    public init(name: String, pictureData: Data? = nil, currentObjectiveIDs: [UUID] = []) {
        self.id = nil
        self.name = name
        self.pictureData = pictureData
        self.currentObjectiveIDs = currentObjectiveIDs
    }
    
    public init() {}
    
    func update(_ object: User) {
        if object.id != nil {
            self.id = object.id
        }
        self.name = object.name
        self.name = object.name
        self.pictureData = object.pictureData
        self.currentObjectiveIDs = object.currentObjectiveIDs
    }
}


struct CreateUser: Migration {
    func prepare(on database: Fluent.Database) -> EventLoopFuture<Void> {
        database.schema(User.schema)
            .id()
            .field("name", .string, .required)
            .field("picture", .data, .required)
            .field("currentObjectiveIDs", .array(of: .uuid))
            .create()
    }

    func revert(on database: Fluent.Database) -> EventLoopFuture<Void> {
        database.schema(User.schema).delete()
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        var result = lhs.name == rhs.name
        if let lhsId = lhs.id, let rhsId = rhs.id {
            result = result && lhsId == rhsId
        }
        return result
    }
}
