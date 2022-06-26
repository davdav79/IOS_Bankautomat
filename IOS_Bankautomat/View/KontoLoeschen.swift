//
//  KontoLoeschen.swift
//  IOS_Bankautomat
//
//  Created by Entwicklung mobiler Applikationen für iOS-Geräte on 24.06.22.
//

import SwiftUI

struct KontoLoeschen: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaktion.timestamp, ascending: true)],
        animation: .default)
    private var transkationen: FetchedResults<Transaktion>
    @FetchRequest(
        sortDescriptors: [])
    private var kontos: FetchedResults<Konto>
    @Binding var aktuKonto:Konto
    @State var alertTit = ""
    @State var alertTxt = ""
    @State var notify = false
    private func KontoLoeschen() {
        
        transkationen.forEach{ transaktion in
            viewContext.delete(transaktion)
        }
        alertTit = "Konto erstellt"
        alertTxt = "IBAN: " + (aktuKonto.iban ?? "")
        viewContext.delete(aktuKonto)
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        notify = true
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack{
            Button(action: KontoLoeschen){
                Text("Konto löschen")
            }.padding().border(.black).background(.red).foregroundColor(.black)
                .alert(isPresented: $notify){
                Alert(title: Text(alertTit), message: Text(alertTxt))}.padding()
            
        }
    }
    
    
}
