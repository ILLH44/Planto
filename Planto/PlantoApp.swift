//
//  PlantoApp.swift
//  Planto
//
//  Created by Hanen Alharbi on 29/05/1448 AH.
//

import SwiftUI

@main
struct PlantoApp: App {
    init() {
        NotificationManager.shared.requestPermission()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
