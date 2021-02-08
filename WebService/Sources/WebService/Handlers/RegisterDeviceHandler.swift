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

struct RegisterDeviceHandler: Handler {
    @Parameter(.http(.path))
    var deviceID: String

    @Environment(\.notificationCenter)
    var notificationCenter: ApodiniNotifications.NotificationCenter
    
    func handle() throws -> EventLoopFuture<Response<String>> {
        notificationCenter
            .register(device: Device(id: deviceID, type: .apns, topics: []))
            .transform(to: Apodini.Response.final("success"))
    }
}
