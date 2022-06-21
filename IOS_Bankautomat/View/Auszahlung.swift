//
//  Auszahlung.swift
//  IOS_Bankautomat
//
//  Created by Stefan Jessel on 21.06.22.
//

import SwiftUI

struct Auszahlung: View {
    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
        Text("Auszahlung")
        Button(action:addItem){
            Text("Auszahlung")
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Transaktion(context: viewContext)
            newItem.timestamp = Date()

            do {
                print("save function")
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct Auszahlung_Previews: PreviewProvider {
    static var previews: some View {
        Auszahlung()
    }
}


