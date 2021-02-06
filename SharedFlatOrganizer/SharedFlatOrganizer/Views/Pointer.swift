//
//  Pointer.swift
//  SharedFlatOrganizer
//
//  Created by Felix Desiderato on 06.02.21.
//

import Foundation
import SwiftUI

struct Pointer: Shape {
    var circleRadius: CGFloat = 3
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: rect.midX, y: rect.minY + rect.height/4))
            p.addLine(to: CGPoint(x: rect.midX, y: rect.midY - circleRadius))
            p.addEllipse(in: CGRect(center: rect.center, radius: circleRadius))
            
        }
    }
}
