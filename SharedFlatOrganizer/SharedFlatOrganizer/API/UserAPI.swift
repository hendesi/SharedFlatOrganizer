//
//  UserAPI.swift
//  SharedFlatOrganizer
//
//  Created by Felix Desiderato on 30.01.21.
//

import Foundation
import Alamofire
import UIKit

struct UserAPI {
    
    private static var demoUsers: [User] = [
        User(name: "Basti", pictureData: UIImage(systemName: "person.fill")?.jpeg(.low)),
        User(name: "Lukas", pictureData: UIImage(systemName: "person.fill")?.jpeg(.low)),
        User(name: "Elias", pictureData: UIImage(systemName: "person.fill")?.jpeg(.low))
    ]
    
    static func createUser(_ user: User, success: @escaping ((User?) -> Void), failure: @escaping ((Error?) -> Void)) {
        AF.request("http://felix.local:8080/v1/api/users/", method: .post, parameters: [user], encoder: JSONParameterEncoder.default)
            .response { response in
                guard let data = response.data else {
                    return failure(nil)
                }
                do {
                    guard let user = try JSONDecoder().decode(UsersWrapper.self, from: data).data.first else { fatalError() }
                    Storage.shared.user = user
                    success(user)
                } catch {
                    failure(error)
                }
            }
    }
    
    static func createDemoUsers(_ users: [User], success: @escaping (([User]) -> Void), failure: @escaping ((Error?) -> Void)) {
        AF.request("http://felix.local:8080/v1/api/users/", method: .post, parameters: users, encoder: JSONParameterEncoder.default)
            .response { response in
                guard let data = response.data else {
                    return failure(nil)
                }
                do {
                    let users = try JSONDecoder().decode(UsersWrapper.self, from: data).data
                    success(users)
                } catch {
                    failure(error)
                }
            }
    }
    
    static func getUsers(success: @escaping (([User]) -> Void), failure: @escaping ((Error?) -> Void)) {
        guard let currentUserId = Storage.shared.user?.id else { return failure(nil) }
        AF.request("http://felix.local:8080/v1/api/users/\(currentUserId)").response { response in
            guard let data = response.data else {
                return failure(nil)
            }
            do {
                let users = try JSONDecoder().decode(UsersWrapper.self, from: data).data
                success(users)
            } catch {
                failure(error)
            }
        }
    }
    
    static func updateUser(_ user: User?, success: @escaping (([User]) -> Void), failure: @escaping ((Error?) -> Void)) {
        guard let user = user else { return failure(nil) }
        AF.request("http://felix.local:8080/v1/api/users/" + user.id.uuidString, method: .put, parameters: Storage.shared.finishedTasks, encoder: JSONParameterEncoder.default)
            .response { response in
                guard let data = response.data else {
                    return failure(nil)
                }
                do {
                    let users = try JSONDecoder().decode(UsersWrapper.self, from: data).data
                    success(users)
                } catch {
                    failure(error)
                }
            }
    }

    static func createDemoData(with user: User, completion: @escaping (([User]) -> Void)) {
        Self.createUser(user, success: { newUser in
            TaskAPI.createTasks(success: { _ in
                Self.createDemoUsers(demoUsers, success: { users in
                    var users = users
                    if newUser != nil { users.append(newUser!) }
                    TaskAPI.setInitialTasksFor(users, success: { usersWithTasks  in
                        let sortedUsers = usersWithTasks.sorted { $0.name < $1.name }
                        Storage.shared.user = sortedUsers.first(where: { $0.id == (Storage.shared.user?.id ?? UUID()) })
                        Self.registerDevice(completion: { _ in
                            completion(sortedUsers)
                        })
                    }, failure: { _ in
                        fatalError()
                    })
                }, failure: { _ in
                    fatalError()
                })
            }, failure: { _ in
                fatalError()
            })
        }, failure: { _ in
            fatalError()
        })
    }
    
    static func registerDevice(completion: @escaping ((Bool) -> Void)) {
        AF.request("http://felix.local:8080/v1/api/devices/a1dc9c505cee0ef67df9fef5dc378ee0911b9eb5901266d7bf34403ad2d169f6", method: .post)
            .response { response in
                guard response.data != nil else {
                    fatalError("failed while registering device")
                }
                completion(true)
            }
    }
}
