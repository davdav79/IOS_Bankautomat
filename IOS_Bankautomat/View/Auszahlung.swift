//
//  Auszahlung.swift
//  IOS_Bankautomat
//
//  Created by Stefan Jessel on 21.06.22.
//

import SwiftUI

struct Auszahlung: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaktion.timestamp, ascending: true)],
        animation: .default)
    private var transaktionen: FetchedResults<Transaktion>
    @FetchRequest(
        sortDescriptors: [])
    private var kontos: FetchedResults<Konto>
    
    @State var alertTxt: String = ""
    @State var alertTit: String = ""
    @State var notify: Bool = false
    @State var betragStr: String = ""
    @State var individual : Bool = false
    @Binding var aktuKonto:Konto
    
    func AppendStr(number:Int, useStr: inout String) -> Void
    {
        if(useStr.count == 0 && number == 0){
            return
        }
        useStr.append(contentsOf: "\(number)")
        
    }
    
    func Auszahlen(betragStr:String)->Bool{
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
        Auszahlen(Double(betrag))
        return true
    }
    
    private func Auszahlen(_ betrag:Double){
        
        if(aktuKonto.stand + aktuKonto.dispogrenze < betrag)
        {
            alertTxt = "Dispokreditgrenze überzogen"
            alertTit = "Fehler"
            notify = true
            return
        }
        let newTransaction = Transaktion(context: viewContext)
        newTransaction.betrag = -betrag
        newTransaction.timestamp = Date.now
        newTransaction.quelle = "Auszahlung"
        newTransaction.zieliban = ""
        newTransaction.konto = Int64(aktuKonto.id)
        
        aktuKonto.stand -= betrag
        
        
        alertTxt = "\(FormatGeld(betrag)) abgehoben.\n Neuer Kontostand: \(FormatGeld(aktuKonto.stand)) "
        alertTit = "Erfolg"
        notify = true
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        presentationMode.wrappedValue.dismiss()
        return
    }
    
    var body: some View {
        if(individual)
        {
            VStack{
                Text("Auszahlung Individuell")
                Text("Betrag: \(betragStr)")
                    .multilineTextAlignment(.center)
                    .frame(width: UIScreen.main.bounds.width/100*50, height: 20)
                    .padding()
                    .border(.black)
                    .background(.gray)
                    .alert(isPresented: $notify){
                        Alert(title: Text(alertTit), message: Text(alertTxt))
                    }
                NumPad(useStr: $betragStr, testDone: $individual, test: Auszahlen, appendStr: AppendStr)
            }
        }
        else
        {
            VStack{
                Text("Auszahlung")
                Button(action: {
                    Auszahlen(20.0)
                }) {
                    Text("20 €").frame(width: UIScreen.main.bounds.width/100*80, height: UIScreen.main.bounds.width/100*15)
                }.background(.gray)
                    .foregroundColor(.black)
                    .shadow(radius: 5)
                Button(action: {
                    Auszahlen(50.0)
                }) {
                    Text("50 €").frame(width: UIScreen.main.bounds.width/100*80, height: UIScreen.main.bounds.width/100*15)
                }.background(.gray)
                    .foregroundColor(.black)
                    .shadow(radius: 5)
                Button(action: {
                    Auszahlen(80.0)
                }) {
                    Text("80 €").frame(width: UIScreen.main.bounds.width/100*80, height: UIScreen.main.bounds.width/100*15)
                }.background(.gray)
                    .foregroundColor(.black)
                    .shadow(radius: 5)
                Button(action: {
                    Auszahlen(100.0)
                }) {
                    Text("100 €").frame(width: UIScreen.main.bounds.width/100*80, height: UIScreen.main.bounds.width/100*15)
                }.background(.gray)
                    .foregroundColor(.black)
                    .shadow(radius: 5)
                Button(action: {
                    individual = true
                }) {
                    Text("Individuell").frame(width: UIScreen.main.bounds.width/100*80, height: UIScreen.main.bounds.width/100*15)
                }.background(.gray)
                    .foregroundColor(.black)
                    .shadow(radius: 5)
            }.alert(isPresented: $notify){
                Alert(title: Text(alertTit), message: Text(alertTxt))
            }
        }
    }
}
