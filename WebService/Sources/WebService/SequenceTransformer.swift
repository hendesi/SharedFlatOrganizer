//
//  File.swift
//  
//
//  Created by Felix Desiderato on 02.02.21.
//

import Foundation
import Apodini
import NIO

struct SequenceTransformer: ResponseTransformer {

    func transform(content: [User]) -> [User] {
        content.sorted { $0.name < $1.name }
//        content.map { users in
//            users.sorted { $0.name < $1.name }
//        }
    }
    
    
}
