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

    let regexNum:String="/^(\\d+(?:[\\.\\,]\\d{2})?$/"
    
    func Regex(_ string:String, format:String) -> Bool{
        let stringPredicate = NSPredicate(format: "SELF MATCHES %@", format)
        print(stringPredicate.evaluate(with: string))
        return stringPredicate.evaluate(with:string)
    }
    func Ueberweisen(){
                
        if(zielIban == ""){
            alertTxt = "Bitte IBAN angeben"
            alertTit = "Fehler"
            notify = true
        }
        let betrag: Double = Double(betragStr) ?? 0.0
        if(betrag == 0.0)
        {
            alertTxt = "Kein Betrag angegeben"
            alertTit = "Fehler"
            notify = true
            return
        }
        
        if(kontos[0].stand + kontos[0].dispogrenze < betrag)
        {
            alertTxt = "Dispokreditgrenze überzogen"
            alertTit = "Fehler"
            notify = true
            return
        }
        
        let newTransaction = Transaktion(context: viewContext)
        newTransaction.betrag = betrag
        newTransaction.timestamp = Date.now
        newTransaction.quelle = "Überweisung"
        newTransaction.zieliban = zielIban
        
        kontos[0].stand -= betrag
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        alertTxt = "Es wurden \(betrag) € Überwiesen\nEmpfänger: \(empfaenger)\nIBAN: \(zielIban) "
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
        }.background(zielIban == "" || empfaenger == "" || betragStr == "" ? .gray : Color.red)
            .foregroundColor(.black)
            .shadow(radius: 5)
            .disabled(zielIban == "" || empfaenger == "" || betragStr == "")
            .alert(isPresented: $notify){
                Alert(title: Text(alertTit), message: Text(alertTxt))}
    }
    
}

struct Ueberweisung_Previews: PreviewProvider {
    static var previews: some View {
        Ueberweisung()
    }
}
