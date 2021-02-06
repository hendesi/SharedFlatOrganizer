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
                }
                ForEach(startingAngles.observableAngles, id: \.id) { angle in
                    Pointer()
                        .stroke(angle.color.asColor(), lineWidth: 3)
                        .rotationEffect(Angle.degrees(angle.value))
                        .animation(.linear(duration: 1))
                }
                Color.clear
            }
        }
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

