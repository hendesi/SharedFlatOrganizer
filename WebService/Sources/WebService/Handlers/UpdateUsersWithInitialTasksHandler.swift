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

struct UpdateUsersWithInitialTasksHandler: Handler {
    @Apodini.Environment(\.database)
    private var database: Database
    
    @Throws(.notFound, reason: "Could not find user in database")
    private var userNotFoundError: ApodiniError
    
    @Environment(\.eventLoopGroup)
    private var eventLoopGroup: EventLoopGroup
    
    @Parameter(.http(.body))
    var users: [User]
    
    var sortedUsers: [User] {
        users.sorted { $0.name < $1.name }
    }
    
    func handle() throws -> EventLoopFuture<[User]> {
        print(users)
        return Task.query(on: database).all().flatMap { tasks in
            eventLoopGroup.next().flatten(
                sortedUsers.enumerated().map { index, user in
                    User
                        .find(user.id, on: database)
                        .unwrap(or: userNotFoundError)
                        .flatMap { foundUser in
                            if let id = tasks[index].id {
                                foundUser.currentObjectiveIDs.append(id)
                            }
                            return foundUser.update(on: database).transform(to: foundUser)
                        }
                }
            )
        }
    }
}
