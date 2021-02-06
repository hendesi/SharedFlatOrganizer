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
        User(name: "Basti", pictureData: UIImage(named: "doneIcon")?.jpeg(.low)),
        User(name: "Lukas", pictureData: UIImage(named: "doneIcon")?.jpeg(.low)),
        User(name: "Elias", pictureData: UIImage(named: "doneIcon")?.jpeg(.low))
    ]
    
    static func createUser(_ user: User, success: @escaping ((User?) -> Void), failure: @escaping ((Error?) -> Void)) {
        AF.request("http://127.0.0.1:8080/v1/api/users/", method: .post, parameters: [user], encoder: JSONParameterEncoder.default)
            .response { response in
                guard let data = response.data else {
                    return failure(nil)
                }
                do {
                    print(user)
                    guard let user = try JSONDecoder().decode(UsersWrapper.self, from: data).data.first else { fatalError() }
                    Storage.shared.user = user
                    success(user)
                } catch {
                    failure(error)
                }
            }
    }
    
    static func createDemoUsers(_ users: [User], success: @escaping (([User]) -> Void), failure: @escaping ((Error?) -> Void)) {
        AF.request("http://127.0.0.1:8080/v1/api/users/", method: .post, parameters: users, encoder: JSONParameterEncoder.default)
            .response { response in
                guard let data = response.data else {
                    return failure(nil)
                }
                do {
                    print(response.debugDescription)
                    let users = try JSONDecoder().decode(UsersWrapper.self, from: data).data
                    print("abc")
                    print(users)
                    success(users)
                } catch {
                    failure(error)
                }
            }
    }
    
    static func getUsers(success: @escaping (([User]) -> Void), failure: @escaping ((Error?) -> Void)) {
        guard let currentUserId = Storage.shared.user?.id else { return failure(nil) }
        AF.request("http://127.0.0.1:8080/v1/api/users/\(currentUserId)").response { response in
            guard let data = response.data else {
                return failure(nil)
            }
            do {
                print(response.debugDescription)
                let users = try JSONDecoder().decode(UsersWrapper.self, from: data).data
                success(users)
            } catch {
                failure(error)
            }
        }
    }
    
    static func updateUser(_ user: User?, success: @escaping (([User]) -> Void), failure: @escaping ((Error?) -> Void)) {
        guard let user = user else { return failure(nil) }
        AF.request("http://127.0.0.1:8080/v1/api/users/" + user.id.uuidString, method: .put, parameters: Storage.shared.finishedTasks, encoder: JSONParameterEncoder.default)
            .response { response in
                guard let data = response.data else {
                    return failure(nil)
                }
                do {
                    print(response.debugDescription)
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
                        completion(sortedUsers)
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
    
    static func getDummyData() {
        AF.request("http://127.0.0.1:8080/v1/api/dummy/users")
            .response { response in
                print(response.debugDescription)
            }
    }
}
