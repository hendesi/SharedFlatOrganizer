//
//  QuarterView.swift
//  SharedFlatOrganizer
//
//  Created by Felix Desiderato on 06.02.21.
//

import Foundation
import SwiftUI

struct QuarterView: View {
    
    let radius : CGFloat
    let startDegree: Double
    let endDegree: Double
    let center: CGPoint
    let user: User
    
    var offset: CGPoint {
        switch startDegree {
        case 0.0:
            return CGPoint(x: radius * 0.4, y: radius * 0.4)
        case 90.0:
            return CGPoint(x: radius * -0.4, y: radius * 0.4)
        case 180:
            return CGPoint(x: radius * -0.4, y: radius * -0.4)
        case 270:
            return CGPoint(x: radius * 0.4, y: radius * -0.4)
        default:
            return CGPoint(x: radius * 0.4, y: radius * 0.4)
        }
    }
    
    var body: some View {
        ZStack {
            Path { path in
                path.move(to: center)
                path.addArc(center: center, radius: radius, startAngle: Angle(degrees: startDegree), endAngle: Angle(degrees: endDegree), clockwise: false)
            }
            .fill(Color(.lightGray).opacity(0.5))
            
            Path { path in
                path.move(to: center)
                path.addArc(center: center, radius: radius, startAngle: Angle(degrees: startDegree), endAngle: Angle(degrees: endDegree), clockwise: false)
            }
            .stroke(Color(.lightGray).opacity(0.5), style: StrokeStyle(lineWidth: 2, lineJoin: .round))
            .overlay(
                Text(user.name)
                    .font(.system(.body, design: .rounded))
                    .bold()
                    .foregroundColor(.white)
                    .offset(x: offset.x, y: offset.y)
            )
        }.aspectRatio(contentMode: .fit)
    }
    
}
