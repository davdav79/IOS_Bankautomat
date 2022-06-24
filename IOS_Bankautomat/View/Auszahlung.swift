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
    
    var body: some View {
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
            NavigationLink{
                AuszahlungIndividuell(presentationAuszahlung: presentationMode,auszahlen: Auszahlen)
            } label: {
                Text("Individuell")
            .frame(width: UIScreen.main.bounds.width/100*80, height: UIScreen.main.bounds.width/100*15)
        }.background(.gray)
            .foregroundColor(.black)
            .shadow(radius: 5)
        }.alert(isPresented: $notify){
            Alert(title: Text(alertTit), message: Text(alertTxt))
        }
        
    }
    
    private func Auszahlen(_ betrag:Double){
        
        if(kontos[0].stand + kontos[0].dispogrenze < betrag)
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
        
        kontos[0].stand -= betrag
        
        
        alertTxt = "\(FormatGeld(betrag)) abgehoben.\n Neuer Kontostand: \(FormatGeld(kontos[0].stand)) "
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
}

struct Auszahlung_Previews: PreviewProvider {
    static var previews: some View {
        Auszahlung()
    }
}


