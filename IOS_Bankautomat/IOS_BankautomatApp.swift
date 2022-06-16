//
//  IOS_BankautomatApp.swift
//  IOS_Bankautomat
//
//  Created by Stefan Jessel on 16.06.22.
//

import SwiftUI

@main
struct IOS_BankautomatApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
