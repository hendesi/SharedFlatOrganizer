//
//  File.swift
//  
//
//  Created by Felix Desiderato on 02.02.21.
//

import Foundation
import Apodini
import ApodiniDatabase
import Fluent
import NIO

struct UpdateTasksForUserHandler: Handler {
    @Parameter(.http(.path))
    var userID: User.IDValue
    
    @Parameter(.http(.body))
    var tasks: [Task]
    
    @Apodini.Environment(\.database)
    var database: Database
    
    @Environment(\.eventLoopGroup)
    private var eventLoopGroup: EventLoopGroup
    
    @Throws(.notFound, reason: "Could not find user in database")
    private var userNotFoundError: ApodiniError
    
    @Throws(.notFound, reason: "Could not retrieve users id")
    private var idNotFoundError: ApodiniError
    
    
    
    func handle() throws -> EventLoopFuture<[User]> {
        eventLoopGroup.next().flatten(
            [
                try updateCurrentUser(),
                try updateFollowingUser()
            ]
        ).flatMap { _ in
            User.query(on: database).all()
        }
//        User
//            .find(userID, on: database)
//            .unwrap(or: userNotFoundError)
//            .flatMap { user in
//                let newObjectives = user.currentObjectiveIDs.removeCollection(tasks.compactMap { $0.id})
//                user.currentObjectiveIDs = newObjectives
//                return user.update(on: database).transform(to: user)
//            }
        
    }
    
    
//    func handle() throws -> EventLoopFuture<[User]> {
//        eventLoopGroup.next().flatten(
//            [
//                try updateCurrentUser(),
//                try updateFollowingUser()
//            ]
//        ).flatMap { _ in
//            User.query(on: database).all()
//        }
//    }
    
    private func updateCurrentUser() throws -> EventLoopFuture<User> {
        User.find(userID, on: database)
            .unwrap(or: userNotFoundError)
            .flatMap { user in
                print("user")
                print(user)
                print("before")
                print(user.currentObjectiveIDs)
                let newObjectives = user.currentObjectiveIDs.removeCollection(tasks.compactMap { $0.id})
                user.currentObjectiveIDs = newObjectives
                print("after")
                print(user.currentObjectiveIDs)
                return user.update(on: database).transform(to: user)
            }
    }
    
    private func updateFollowingUser() throws -> EventLoopFuture<User> {
        User.query(on: database).all().flatMap { users in
            let user = nextUser(in: users)
            return User
                .find(user?.id, on: database)
                .unwrap(or: userNotFoundError)
                .flatMap { nextUser in
                    nextUser.currentObjectiveIDs.append(contentsOf: tasks.compactMap { $0.id} )
                    return nextUser.update(on: database).transform(to: nextUser)
            }
        }
//        User.query(on: database).all().flatMapThrowing { users in
//            for (index, user) in users.enumerated() {
//                if user.id == userID {
//                    let modIndex = (index + 1) % users.count
//                    let nextUser = users[modIndex]
//                    nextUser.currentObjectiveIDs.append(contentsOf: tasks.compactMap { $0.id} )
//                    return nextUser.update(on: database).transform(to: nextUser)
//                }
//            }
//        }
//        guard let nextUser = nextUser else { throw userNotFoundError }
//        return User.find(userID, on: database)
//
//            .flatMap { user in
//                User.find(nextUser.id, on: database)
//                    .unwrap(or: userNotFoundError)
//                    .flatMap { nextFoundUser in
//                        nextFoundUser.currentObjectiveIDs.append(contentsOf: user.currentObjectiveIDs)
//                        return nextFoundUser.update(on: database).transform(to: nextFoundUser)
//                    }
//            }
        
    }
    
    private func nextUser(in users: [User]) -> User? {
        let users = users.sorted { $0.name < $1.name }
        for (index, user) in users.enumerated() {
            if user.id == userID {
                let modIndex = (index + 1) % users.count
                return users[modIndex]
            }
        }
        return nil
    }
}
