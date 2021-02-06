//
//  ColorCatalog.swift
//  SharedFlatOrganizer
//
//  Created by Felix Desiderato on 23.01.21.
//

import Foundation
import UIKit
import SwiftUI

class ColorCatalog {
    
    static var primaryColor: UIColor {
        return UIColor(red: 34/255, green: 139/255, blue: 243/255, alpha: 1.0)
    }
}

extension UIColor {
    func asColor() -> Color {
        Color(self)
    }
}
