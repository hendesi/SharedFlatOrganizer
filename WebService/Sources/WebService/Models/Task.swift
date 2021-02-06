//
//  File.swift
//
//
//  Created by Felix Desiderato on 30.01.21.
//

import Foundation
import Fluent
@testable import ApodiniDatabase
@testable import Apodini
import FluentMongoDriver

final class Task: DatabaseModel {
    static var schema: String = "Tasks"
    
    @ID
    var id: UUID?
    @Field(key: "name")
    var name: String
    @Field(key: "hexString")
    var hexString: String
    
    init(name: String, hexString: String) {
        self.id = nil
        self.name = name
        self.hexString = hexString
    }
    
    init() {}
    
    func update(_ object: Task) {
        if object.id != nil {
            self.id = object.id
        }
        self.name = object.name
        self.hexString = object.hexString
    }
}


struct CreateTask: Migration {
    func prepare(on database: Fluent.Database) -> EventLoopFuture<Void> {
        database.schema(Task.schema)
            .id()
            .field("name", .string, .required)
            .field("hexString", .string, .required)
            .create()
    }

    func revert(on database: Fluent.Database) -> EventLoopFuture<Void> {
        database.schema(Task.schema).delete()
    }
}

extension Task: Equatable {
    static func == (lhs: Task, rhs: Task) -> Bool {
        var result = lhs.name == rhs.name && lhs.hexString == rhs.hexString
        if let lhsId = lhs.id, let rhsId = rhs.id {
            result = result && lhsId == rhsId
        }
        return result
    }
}
