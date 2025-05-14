//
//  penpalApp.swift
//  penpal
//

import SwiftUI

@main
struct penpalApp: App {
    @StateObject var session = Session()
    
    var body: some Scene {
        WindowGroup {
            ContentView(session: session)
                .environmentObject(session)
        }
    }
}
