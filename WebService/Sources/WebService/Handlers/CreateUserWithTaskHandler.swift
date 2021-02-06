//
//  File.swift
//  
//
//  Created by Felix Desiderato on 02.02.21.
//

import Foundation
import Apodini
import Fluent
import NIO

struct CreateUsersWithTaskHandler: Handler {
    @Apodini.Environment(\.database)
    private var database: Database

    @Environment(\.eventLoopGroup)
    private var eventLoopGroup: EventLoopGroup
    
    @Parameter(.http(.body))
    var users: [User]
    
    var sortedUsers: [User] {
        users.sorted { $0.name < $1.name }
    }
    
    func handle() throws -> EventLoopFuture<[User]> {
        Task.query(on: database).all().flatMap { tasks in
            eventLoopGroup.next().flatten(
                sortedUsers.enumerated().map { index, user in
                    if let id = tasks[index].id {
                        user.currentObjectiveIDs.append(id)
                    }
                    return user.save(on: database).transform(to: user)
                }
            )
        }
    }
}
