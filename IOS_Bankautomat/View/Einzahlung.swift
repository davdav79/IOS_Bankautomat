//
//  Einzahlung.swift
//  IOS_Bankautomat
//
//  Created by Entwicklung mobiler Applikationen für iOS-Geräte on 21.06.22.
//

import SwiftUI

struct Einzahlung: View {
    @Environment(\.managedObjectContext) var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaktion.timestamp, ascending: true)],
        animation: .default)
    private var transaktionen: FetchedResults<Transaktion>
    @FetchRequest(
        sortDescriptors: [])
    private var kontos: FetchedResults<Konto>
    
    @State var next: Bool = false
    
    @State var betragStr: String = ""
    @State var alertTxt: String = ""
    @State var alertTit: String = ""
    @State var notify: Bool = false
    @Binding var aktuKonto:Konto
    
    func Einzahlen(betragStr: String) -> Bool{
        let betrag: Int = Int(betragStr) ?? 0
        if(betrag == 0){
            alertTxt = "Mindestens 5€ einführen"
            alertTit = "Fehler"
            notify = true
            return false
        }
        if(betrag % 5 != 0){
            alertTxt = "Nur Geldscheine einführen"
            alertTit = "Fehler"
            notify = true
            return false
        }
        let newTransaction = Transaktion(context: viewContext)
        newTransaction.betrag = Double(betrag)
        newTransaction.timestamp = Date.now
        newTransaction.quelle = "Einzahlung"
        newTransaction.zieliban = ""
        newTransaction.konto = Int64(aktuKonto.id)
        
        aktuKonto.stand += Double(betrag)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        alertTxt = "Es wurden \(betrag) € eingezahlt"
        alertTit = "Erfolg"
        notify = true
        return true
    }
    
    func AppendStr(number:Int, useStr: inout String) -> Void
    {
        if(useStr.count == 0 && number == 0){
            return
        }
        useStr.append(contentsOf: "\(number)")
        
    }
    var body: some View {
        VStack{
            Text("Einzahlung").frame(width: UIScreen.main.bounds.width/100*80, height: 20).padding()
            Text("Betrag: \(betragStr)")
                .multilineTextAlignment(.center)
                .frame(width: UIScreen.main.bounds.width/100*50, height: 20)
                .padding()
                .border(.black)
                .background(.gray)
                .alert(isPresented: $notify){
                    Alert(title: Text(alertTit), message: Text(alertTxt))}
            NumPad(useStr: $betragStr, testDone: $next, test:Einzahlen , appendStr: AppendStr)
        }
    }
}
