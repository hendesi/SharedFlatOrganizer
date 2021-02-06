//
//  ClockView.swift
//  SharedFlatOrganizer
//
//  Created by Felix Desiderato on 22.01.21.
//

import SwiftUI

struct ClockView: View {
    
    let users: [User]
    let tasks: [Task] = Storage.shared.tasks
    let angles: [(Double, Double)] = [(0, 90), (90, 180), (180, 270), (270, 360)]
    
    @ObservedObject
    var startingAngles: ObservableAnglesWrapper
    
    var body: some View {
        GeometryReader { reader in
            let rect = reader.frame(in: .local)
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let radius = reader.size.width / 2
            ZStack {
                ForEach(Array(zip(users.indices, users)), id: \.0) { index, user in
                    let angle = angles[index]
                    QuarterView(radius: radius, startDegree: angle.0, endDegree: angle.1, center: center, user: user)
//                    ForEach(Array(zip(observedPointerAngles.indices, observedPointerAngles)), id: \.0) { index, observedPointerAngle in
//                        Pointer()
//                            .stroke(observedPointerAngle.color, lineWidth: 3)
//                            .rotationEffect(Angle.degrees(observedPointerAngle.value))
//                            .animation(.linear)
//                        }
                }
                ForEach(startingAngles.observableAngles, id: \.id) { angle in
                    Pointer()
                        .stroke(Color(angle.color), lineWidth: 3)
                        .rotationEffect(Angle.degrees(angle.value))
                        .animation(.linear)
                }
                Color.clear
            }
        }
    }
}

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

extension CGRect {
    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }
    
    init(center: CGPoint, radius: CGFloat) {
        self = CGRect(
            x: center.x - radius,
            y: center.y - radius,
            width: radius * 2,
            height: radius * 2
        )
    }
}

class ObservableAnglesWrapper: ObservableObject {
    @Published var observableAngles: [ObservableAngle]
    
    init(_ observableAngles: [ObservableAngle]) {
        self.observableAngles = observableAngles
    }
}

struct ObservableAngle {
    var value: Double
    var color: UIColor
    var id: UUID
    
    init(_ value: Double, color: UIColor) {
        self.id = UUID()
        self.value = value
        self.color = color
    }
}

