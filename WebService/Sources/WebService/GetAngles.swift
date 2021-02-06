//
//  File.swift
//  
//
//  Created by Felix Desiderato on 05.02.21.
//

import Foundation
import Apodini
import ApodiniDatabase
import Fluent
import NIO

struct GetAngles: Handler {
    @Environment(\.users)
    var users: [User]
    
    @Apodini.Environment(\.database)
    var database: Database
    
    @Throws(.notFound, reason: "Could not retrieve tasks")
    private var idNotFoundError: ApodiniError
    
    func handle() throws -> String {
//        Task.query(on: database).all().map { tasks in
//            for task in tasks {
//                guard let id = task.id else { fatalError("id is nil") }
//                let currentUser = users.first(where: { $0.currentObjectiveIDs.contains(id) })
//
//            }
//        }
        ""
    }
    
//    private func getAngleFor(_ user: User) -> Double {
//        guard let index = users.firstIndex(of: user) else { fatalError("user not in db")}
//        switch index {
//        case 0:
//            return
//        case 1:
//        case 2:
//        case 3:
//        default:
//        }
//    }
}

struct Pointer: Encodable {
    let angle: Double
    let hexColorString: String
}
