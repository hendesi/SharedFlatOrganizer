//
//  User.swift
//  SharedFlatOrganizer
//
//  Created by Felix Desiderato on 25.01.21.
//

import Foundation
import UIKit

struct User: Codable {
    var id: UUID
    var name: String
    var pictureData: Data?
    var currentObjectiveIDs: [UUID]
    
    var currentObjectives: [Task] {
        currentObjectiveIDs.compactMap { Storage.shared.findTaskById($0) }
    }
    
    var picture: UIImage {
        guard let data = pictureData else {
            return UIImage(named: "doneIcon")!
        }
        return UIImage(data: data) ?? UIImage(named: "doneIcon")!
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, pictureData, currentObjectiveIDs
    }
    
    init(name: String, currentObjectiveIDs: [UUID]) {
        self.id = UUID()
        self.name = name
        self.currentObjectiveIDs = currentObjectiveIDs
    }
    
    init(name: String?, pictureData: Data?) {
        self.id = UUID()
        self.name = name ?? ""
        self.pictureData = pictureData
        self.currentObjectiveIDs = []
    }
    
    init(id: UUID, name: String, pictureData: Data?, currentObjectiveIDs: [UUID]) {
        self.id = id
        self.name = name
        self.pictureData = pictureData
        self.currentObjectiveIDs = currentObjectiveIDs
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let id = try values.decode(UUID.self, forKey: .id)
        let name = try values.decode(String.self, forKey: .name)
        var pictureData: Data?
        if let picture = try values.decodeIfPresent(Data.self, forKey: .pictureData) {
            pictureData = picture
        }
        let currentObjectiveIDs = try values.decode([UUID].self, forKey: .currentObjectiveIDs)
        self.init(id: id, name: name, pictureData: pictureData, currentObjectiveIDs: currentObjectiveIDs)
    }
    
    func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try values.encode(id, forKey: .id)
        try values.encode(name, forKey: .name)
        try values.encode(pictureData, forKey: .pictureData)
        try values.encode(currentObjectiveIDs, forKey: .currentObjectiveIDs)
    }
}

struct UserWrapper: Codable {
    let data: User
}

struct UsersWrapper: Codable {
    let data: [User]
}
