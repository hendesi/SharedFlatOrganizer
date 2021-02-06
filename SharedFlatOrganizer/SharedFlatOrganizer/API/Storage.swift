//
//  Storage.swift
//  SharedFlatOrganizer
//
//  Created by Felix Desiderato on 31.01.21.
//

import Foundation

let CurrentUserStorageKey: String = "CurrentUserKey"
let TaskStorageKey: String = "TaskStorageKey"

class Storage {
    
    static let shared: Storage = {
        let storage = Storage()
        return storage
    }()
    
    private var _currentUser: User?
    var user: User? {
        set {
            do {
                _currentUser = newValue
                let data = try JSONEncoder().encode(newValue)
                UserDefaults.standard.set(data, forKey: CurrentUserStorageKey)
            } catch {
                fatalError("failed to encode user: \(error.localizedDescription)")
            }
        }
        get {
            do {
                if let user = _currentUser {
                    return user
                }
                guard let data = UserDefaults.standard.data(forKey: CurrentUserStorageKey) else { return nil }
                let user = try JSONDecoder().decode(User.self, from: data)
                return user
            } catch {
                fatalError("failed to encode user: \(error.localizedDescription)")
            }
        }
    }
    
    private var _tasks: [Task] = []
    var tasks: [Task] {
        set {
            do {
                _tasks = newValue
                let data = try JSONEncoder().encode(newValue)
                UserDefaults.standard.set(data, forKey: TaskStorageKey)
            } catch {
                fatalError("failed to encode tasks: \(error.localizedDescription)")
            }
        }
        get {
            do {
                if !_tasks.isEmpty {
                    return _tasks
                }
                guard let data = UserDefaults.standard.data(forKey: TaskStorageKey) else { return [] }
                let tasks = try JSONDecoder().decode([Task].self, from: data)
                return tasks
            } catch {
                fatalError("failed to encode tasks: \(error.localizedDescription)")
            }
        }
    }
    
    private var _finishedTasks: [Task] = []
    var finishedTasks: [Task] {
        set { _finishedTasks = newValue }
        get { _finishedTasks }
    }
    
    func findTaskById(_ identifier: UUID) -> Task? {
        for task in self.tasks {
            if let foundTask = task.findById(identifier) {
                return foundTask
            }
        }
        return nil
    }
}
