//
//  ContentView.swift
//  IOS_Bankautomat
//
//  Created by Stefan Jessel on 16.06.22.
//

import SwiftUI
import CoreData

func FormatGeld(_ stand: Double)->String{
    return String(format: "%@%.2f €", "", stand)
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaktion.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Transaktion>
    @FetchRequest(
        sortDescriptors: [])
    private var kontos: FetchedResults<Konto>
    var body: some View {
        if(kontos.count > 0 && kontos[0].sperre == false){
            VStack{
                NavigationView {
                    List {
                        NavigationLink{
                            PinAbfrage(nextView: AnyView(Auszahlung()))
                        } label: {
                            Text("Auszahlung")
                        }.isDetailLink(false)
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
                            Text("Kontostand")
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
                        NavigationLink{
                            PinAbfrage(nextView: AnyView(KontoLoeschen()))
                        } label: {
                            Text("Konto Löschen")
                        }
                    }
                }
            }
        }else{
            VStack{
                if(kontos.count == 0){
                    Button(action:KontoHinzufuegen){
                    Text("Konto Erstellen Pin: 1234")
                    }.padding().border(.black).background(.gray).foregroundColor(.black)
                }else{
                Button(action:{
                    kontos[0].sperre = false
                }){
                    Text("Konto entsperren")
                }
                }
            }
        }
    }

    private func KontoHinzufuegen() {
        withAnimation {
            let newItem = Konto(context: viewContext)
            newItem.pin = [1,2,3,4]
            newItem.iban = "1234567890"
            newItem.stand = 0
            newItem.dispogrenze = 400
            newItem.sperre = false
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
