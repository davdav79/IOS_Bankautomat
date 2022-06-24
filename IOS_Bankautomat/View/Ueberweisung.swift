//
//  Ueberweisung.swift
//  IOS_Bankautomat
//
//  Created by Entwicklung mobiler Applikationen für iOS-Geräte on 21.06.22.
//

import SwiftUI

struct Ueberweisung: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaktion.timestamp, ascending: true)],
        animation: .default)
    private var transaktionen: FetchedResults<Transaktion>
    @FetchRequest(
        sortDescriptors: [])
    private var kontos: FetchedResults<Konto>
    @State var zielIban:String = ""
    @State var empfaenger:String=""
    @State var betrag:String=""
    let regexNum:String="/^(\\d+(?:[\\.\\,]\\d{2})?$/"
    
    func Regex(_ string:String, format:String) -> Bool{
        let stringPredicate = NSPredicate(format: "SELF MATCHES %@", format)
        print(stringPredicate.evaluate(with: string))
        return stringPredicate.evaluate(with:string)
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
            TextField(text: $betrag){
                Text("Betrag")
            }.disableAutocorrection(true)
                .keyboardType(.decimalPad)
            
    }
        Button(action: {
        }) {
            Text("Überweisen").frame(width: 80, height: 80)
        }.background(.gray)
            .foregroundColor(.black)
            .shadow(radius: 5)
            .disabled(zielIban == "" || empfaenger == "" || betrag == "")
        
    }
    
}

struct Ueberweisung_Previews: PreviewProvider {
    static var previews: some View {
        Ueberweisung()
    }
}
