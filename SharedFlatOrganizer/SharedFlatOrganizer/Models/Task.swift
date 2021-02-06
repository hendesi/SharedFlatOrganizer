//
//  Task.swift
//  SharedFlatOrganizer
//
//  Created by Felix Desiderato on 25.01.21.
//

import Foundation
import UIKit

enum Task: Codable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let vals = self.values
        try container.encode(vals.0, forKey: .id)
        try container.encode(vals.1, forKey: .name)
        try container.encode(vals.2, forKey: .hexString)
    }
    
    case plasticTrash(UUID, String, String)
    case mail(UUID, String, String)
    case bioTrash(UUID, String, String)
    case paperTrash(UUID, String, String)
    
    enum CodingKeys: String, CodingKey {
        case id, name, hexString
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let id = try values.decode(UUID.self, forKey: .id)
        let name = try values.decode(String.self, forKey: .name)
        let hexString = try values.decode(String.self, forKey: .hexString)
        self.init(id, name: name, hexString: hexString)
    }
    
    init(_ id: UUID = UUID(), name: String, hexString: String) {
        switch name {
        case "Plastic Trash":
            self = .plasticTrash(id, name, hexString)
        case "Mail":
            self = .mail(id, name, hexString)
        case "Bio Trash":
            self = .bioTrash(id, name, hexString)
        case "Paper Trash":
            self = .paperTrash(id, name, hexString)
        default:
            fatalError("name \(name) not in enums. Should not happen")
        }
    }
    
    var values: (UUID, String, String) {
        switch self {
        case let .bioTrash(id, name, hexString):
            return (id, name, hexString)
        case let .mail(id, name, hexString):
            return (id, name, hexString)
        case let .plasticTrash(id, name, hexString):
            return (id, name, hexString)
        case let .paperTrash(id, name, hexString):
            return (id, name, hexString)
        }
    }
    
    var name: String {
        switch self {
        case let .plasticTrash(_,name,_):
            return name
        case let .mail(_,name,_):
            return name
        case let .bioTrash(_,name,_):
            return name
        case let .paperTrash(_,name,_):
            return name
        }
    }
    
    var color: UIColor {
        switch self {
        case let .plasticTrash(_, _, hexString):
            return UIColor(hexString: hexString)
        case let .mail(_, _, hexString):
            return UIColor(hexString: hexString)
        case let .bioTrash(_, _, hexString):
            return UIColor(hexString: hexString)
        case let .paperTrash(_, _, hexString):
            return UIColor(hexString: hexString)
        }
    }
    
    func findById(_ identifier: UUID) -> Self? {
        switch self {
        case let .bioTrash(id, name, hexString) where id == identifier:
            return .bioTrash(id, name, hexString)
        case let .mail(id, name, hexString) where id == identifier:
            return .mail(id, name, hexString)
        case let .plasticTrash(id, name, hexString) where id == identifier:
            return .plasticTrash(id, name, hexString)
        case let .paperTrash(id, name, hexString) where id == identifier:
            return .paperTrash(id, name, hexString)
        default:
            return nil
        }
    }
}

struct TaskWrapper: Codable {
    let data: [Task]
}
