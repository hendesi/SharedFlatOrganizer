//
//  File.swift
//  
//
//  Created by Felix Desiderato on 02.02.21.
//

import Foundation
import Apodini
import ApodiniDatabase

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
