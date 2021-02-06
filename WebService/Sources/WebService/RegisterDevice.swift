//
//  File.swift
//  
//
//  Created by Felix Desiderato on 02.02.21.
//

import Foundation
import Apodini
import ApodiniNotifications
import NIO

struct RegisterDevice: Handler {
    @Parameter(.http(.path))
    var userId: User.IDValue

    @Environment(\.notificationCenter) var notificationCenter: ApodiniNotifications.NotificationCenter
    
    func handle() throws -> EventLoopFuture<Response<String>> {
        notificationCenter
            .register(device: Device(id: userId.uuidString, type: .apns, topics: []))
            .transform(to: Apodini.Response.final("success"))
    }
}
