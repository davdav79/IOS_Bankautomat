//
//  Ueberweisung.swift
//  IOS_Bankautomat
//
//  Created by Entwicklung mobiler Applikationen für iOS-Geräte on 21.06.22.
//

import SwiftUI

struct Ueberweisung: View {
    @Environment(\.managedObjectContext) var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaktion.timestamp, ascending: true)],
        animation: .default)
    private var transaktionen: FetchedResults<Transaktion>
    @FetchRequest(
        sortDescriptors: [])
    private var kontos: FetchedResults<Konto>
    @State var zielIban:String = ""
    @State var empfaenger:String=""
    @State var betragStr:String=""
    
    @State var alertTxt: String = ""
    @State var alertTit: String = ""
    @State var notify: Bool = false
    @State var enableAcceptButton = false
    @Binding var aktuKonto:Konto
    
    func Ueberweisen(){
        var zielKonto:Konto = Konto()
        
        //check Betrag foramt
        let filterKomma = betragStr.filter{ $0 == "," }.count
        if(filterKomma > 1)
        {
            alertTxt = "Betrag enthält mehr als ein Komma"
            alertTit = "Fehler"
            notify = true
            return
        }
        //check iban Format
        for index in 1..<zielIban.count{
            let letter = zielIban[zielIban.index(zielIban.startIndex, offsetBy: index)]
            
            if(index < 2)
            {
                if(!(letter.isLetter))
                {
                    alertTxt = "IBAN falsches Format"
                    alertTit = "Fehler"
                    notify = true
                    return
                }
            }
            else
            {
                if(!(letter.isNumber))
                {
                    alertTxt = "IBAN falsches Format"
                    alertTit = "Fehler"
                    notify = true
                    return
                }
            }
        }
        
        betragStr = betragStr.replacingOccurrences(of: ",", with: ".")
        
        let betrag: Double = Double(betragStr) ?? 0.0
        if(betrag == 0.0)
        {
            alertTxt = "Kein Betrag angegeben"
            alertTit = "Fehler"
            notify = true
            betragStr = betragStr.replacingOccurrences(of: ".", with: ",")
            return
        }
        
        if(betrag < 0.0)
        {
            alertTxt = "Bitte Betrag größer 0 angeben"
            alertTit = "Fehler"
            notify = true
            betragStr = betragStr.replacingOccurrences(of: ".", with: ",")
            return
        }
        
        if(aktuKonto.stand + aktuKonto.dispogrenze < betrag)
        {
            alertTxt = "Dispokreditgrenze überzogen"
            alertTit = "Fehler"
            notify = true
            betragStr = betragStr.replacingOccurrences(of: ".", with: ",")
            return
        }
        print(zielKonto)
        //check if target konto exists
        var foundKonto = false
        kontos.forEach{ konto in
            if(konto.iban == zielIban){
                zielKonto = konto
                foundKonto = true
            }
        }
        if(foundKonto == false){
            alertTxt = "IBAN existiert nicht"
            alertTit = "Fehler"
            notify = true
            return
        }
        let newTransaction = Transaktion(context: viewContext)
        newTransaction.betrag = -betrag
        newTransaction.timestamp = Date.now
        newTransaction.quelle = "Überweisung Ausgehen"
        newTransaction.zieliban = zielIban
        newTransaction.konto = aktuKonto.id
        aktuKonto.stand -= betrag
        
        let newTransactionSend = Transaktion(context: viewContext)
        newTransactionSend.betrag = betrag
        newTransactionSend.timestamp = Date.now
        newTransactionSend.quelle = "Überweisung Eingehend"
        newTransactionSend.zieliban = zielIban
        newTransactionSend.konto = zielKonto.id
        
        zielKonto.stand += betrag
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        alertTxt = "Es wurden \(FormatGeld(betrag)) Überwiesen\nEmpfänger: \(empfaenger)\nIBAN: \(zielIban) "
        alertTit = "Erfolg"
        notify = true
        zielIban = ""
        betragStr = ""
        empfaenger = ""
    }
    
    var body: some View {
        Text("Ueberweisung")
        Form{
            Text("IBAN")
            TextField(text: $zielIban){
                Text("IBAN")
            }.disableAutocorrection(true)
            Text("Empfänger")
            TextField(text: $empfaenger){
                Text("Empfänger")
            }.disableAutocorrection(true)
            Text("Betrag")
            TextField(text: $betragStr){
                Text("Betrag")
            }.disableAutocorrection(true)
                .keyboardType(.decimalPad)
            
    }
        Button(action: {
            Ueberweisen()
        }) {
            Text("Überweisen").frame(width: UIScreen.main.bounds.width/100*80, height: UIScreen.main.bounds.width/100*15)
        }.background((zielIban != "" && empfaenger != "" && betragStr != "") ? .gray : .red)
            .foregroundColor(.black)
            .shadow(radius: 5)
            .disabled(zielIban == "" || empfaenger == "" || betragStr == "")
            .alert(isPresented: $notify){
                Alert(title: Text(alertTit), message: Text(alertTxt))}
    }
    
}
