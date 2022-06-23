//
//  ContentView.swift
//  IOS_Bankautomat
//
//  Created by Stefan Jessel on 16.06.22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaktion.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Transaktion>
    @FetchRequest(
        sortDescriptors: [])
    private var items2: FetchedResults<Konto>
    var body: some View {
        VStack{
            /*Button(action:addItem){
                Text("add Item")
            }*/
            NavigationView {
                List {
                    NavigationLink{
                        PinAbfrage(nextView: AnyView(Auszahlung()))
                    } label: {
                        Text("Auszahlung")
                    }
                    NavigationLink{
                        Einzahlung()
                    } label: {
                        Text("Einzahlung")
                    }
                    NavigationLink{
                        Ueberweisung()
                    } label: {
                        Text("Überweisung")
                    }
                    NavigationLink{
                        PinAbfrage(nextView: AnyView(Kontostand()))
                    } label: {
                        Text("Kontostand Abfrage")
                    }
                    NavigationLink{
                        KontoAuszug()
                    } label: {
                        Text("Kontoauszug")
                    }
                    NavigationLink{
                        PinAbfrage(nextView: AnyView(PinAendern()))
                    } label: {
                        Text("Pin ändern")
                    }
                }
            }
            /*ForEach(items){ konto in
                Text(konto.iban!, formatter: itemFormatter)
            }*/
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Konto(context: viewContext)
            newItem.pin = [1,2,3,4]
            newItem.iban = "1234567890"
            newItem.stand = 0
            newItem.dispogrenze = 400
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    /*private func deleteItems() {
        withAnimation {
            items.forEach(viewContext.delete)
            items2.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }*/
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
