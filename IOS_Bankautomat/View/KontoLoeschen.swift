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
    @Binding var kontoCheck:Bool
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
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        notify = true
        if(kontos.count == 0){
            kontoCheck = false
        }
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack{
            Text("Konto löschen").padding().font(.largeTitle)
            List{
                Text("ID: \(aktuKonto.id)")
                Text("IBAN: " + (aktuKonto.iban ?? ""))
            }
            Button(action: KontoLoeschen){
                Text("Konto löschen")
            }.padding().border(.black).background(.red).foregroundColor(.black)
                .alert(isPresented: $notify){
                Alert(title: Text(alertTit), message: Text(alertTxt))}.padding()
        }
        Spacer()
    }
    
    
}
