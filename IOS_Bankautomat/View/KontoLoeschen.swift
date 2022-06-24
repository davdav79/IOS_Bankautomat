//
//  KontoLoeschen.swift
//  IOS_Bankautomat
//
//  Created by Entwicklung mobiler Applikationen für iOS-Geräte on 24.06.22.
//

import SwiftUI

struct KontoLoeschen: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaktion.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Transaktion>
    @FetchRequest(
        sortDescriptors: [])
    private var kontos: FetchedResults<Konto>
    var body: some View {
        VStack{
            Button(action: KontoLoeschen){
                Text("Konto löschen")
            }.padding().border(.black).background(.red).foregroundColor(.black)
        }
    }
    private func KontoLoeschen() {
        withAnimation {
            items.forEach(viewContext.delete)
            kontos.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }}

struct KontoLoeschen_Previews: PreviewProvider {
    static var previews: some View {
        KontoLoeschen()
    }
}
