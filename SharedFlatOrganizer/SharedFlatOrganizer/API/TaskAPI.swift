//
//  TaskAPI.swift
//  SharedFlatOrganizer
//
//  Created by Felix Desiderato on 31.01.21.
//

import Foundation
import Alamofire

struct TaskAPI {
    
    static var defaultTasks: [Task] = [
        Task(name: "Paper Trash", hexString: "0055A9"),
        Task(name: "Plastic Trash", hexString: "ADE1DA"),
        Task(name: "Bio Trash", hexString: "4A2C0F"),
        Task(name: "Mail", hexString: "E0CB13")
    ]
    
    static func createTasks(success: @escaping (([Task]) -> Void), failure: @escaping ((Error?) -> Void)) {
        AF.request("http://127.0.0.1:8080/v1/api/tasks/", method: .post, parameters: defaultTasks, encoder: JSONParameterEncoder.default)
            .response { response in
                do {
                    guard let data = response.data else { fatalError() }
                    let tasks = try JSONDecoder().decode(TaskWrapper.self, from: data).data
                    Storage.shared.tasks = tasks
                    success(tasks)
                } catch {
                    failure(error)
                }
            }
    }
    
    static func setInitialTasksFor(_ users: [User], success: @escaping (([User]) -> Void), failure: @escaping ((Error?) -> Void)) {
        AF.request("http://127.0.0.1:8080/v1/api/tasks/", method: .put, parameters: users, encoder: JSONParameterEncoder.default)
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
    
    static func getAngles(for users: [User]) -> [ObservableAngle] {
        let users = users.sorted { $0.name < $1.name }
        var observableAngles: [ObservableAngle] = []
        let start: Double = 45
        let quarter: Double = 90
        let taskMultiplier: Double = 5
        users.enumerated().forEach { index, user in
            observableAngles.append(contentsOf: user.currentObjectives.enumerated().map { taskIndex, task in
                let userValue = start + quarter * Double(index + 1)
                let taskValue = Double(taskIndex) * taskMultiplier
                let value = (userValue + taskValue).truncatingRemainder(dividingBy: 360)
                return ObservableAngle(value, color: task.color)
            })
        }
        return observableAngles
    }
}
