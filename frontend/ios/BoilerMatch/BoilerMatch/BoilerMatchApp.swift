//
//  BoilerMatchApp.swift
//  BoilerMatch
//
//  Created by Omniscient on 2/21/25.
//

import SwiftUI

@main
struct BoilerMatchApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
