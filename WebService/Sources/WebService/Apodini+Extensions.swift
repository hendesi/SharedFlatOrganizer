//
//  File.swift
//  
//
//  Created by Felix Desiderato on 02.02.21.
//

import Foundation
import Apodini
import ApodiniDatabase

extension Application {
    var users: [User] {
        get {
//            if let storedUsers = self.storage[UsersKey] {
//                return storedUsers.sorted { $0.name < $1.name }
//            }
            do {
                let users = try self.database
                    .query(User.self)
                    .all()
                    .wait()
                    .sorted { $0.name < $1.name }
                self.storage[UserKey.self] = users
                return users
            } catch {
                fatalError(error.localizedDescription)
            }
        }
//        set { self.storage[UsersKey.self] = newValue }
    }
    
    var tasks: [Task] {
        if let tasks = self.storage[TaskKey.self] {
            return tasks
        }
        do {
            let tasks = try self.database
                .query(Task.self)
                .all()
                .wait()
            self.storage[TaskKey.self] = tasks
            return tasks
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

struct UserKey: StorageKey {
    typealias Value = [User]
}

struct TaskKey: StorageKey {
    typealias Value = [Task]
}

extension Array where Element: Equatable {
    func removeCollection(_ collection: [Element]) -> Self {
        var newArray: [Element] = []
        for element in self {
            if collection.contains(element) { break }
            newArray.append(element)
        }
        return newArray
    }
}
