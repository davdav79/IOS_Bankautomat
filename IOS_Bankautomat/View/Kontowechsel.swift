//
//  Kontowechsel.swift
//  IOS_Bankautomat
//
//  Created by Entwicklung mobiler Applikationen für iOS-Geräte on 24.06.22.
//

import SwiftUI

struct KontoWechsel: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [])
    private var kontos: FetchedResults<Konto>
    @State var alertTit = ""
    @State var alertTxt = ""
    @Binding var aktuKonto:Konto
    @Binding var initCheck:Bool
    @State var notify:Bool = false
    func NeuesKonto(){
        //aktuKonto = kontos
        let newItem = Konto(context: viewContext)
        newItem.pin = [1,1,1,1]//[Int.random(in: 0...9),Int.random(in: 0...9),Int.random(in: 0...9),Int.random(in: 0...9)]
        newItem.iban = "DE" + String(Int.random(in: 1_000_000_000...9_999_999_999))
        newItem.stand = 0
        newItem.dispogrenze = 400
        newItem.sperre = false
        aktuKonto = newItem
        if (kontos.count > 0){
            newItem.id =  kontos[kontos.count-1].id + 1
        }else{
            newItem.id = 1
        }
        print(newItem.id)
            
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        alertTit = "Konto erstellt"
        alertTxt = "IBAN: " + newItem.iban! + "\n PIN: "
        for num in newItem.pin!{
            alertTxt += String(num)
        }
        notify = true
        presentationMode.wrappedValue.dismiss()
        initCheck = true
    }
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaktion.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Transaktion>
    func DeleteAll(){
        kontos.forEach{ konto in viewContext.delete(konto)}
        items.forEach{item in viewContext.delete(item)}
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
    }
    var body: some View {
        Text("Kontowechsel").padding().font(.largeTitle)
        Button(action:DeleteAll){
            Text("delete all")
        }
        List{
            Button(action: NeuesKonto){
                Text("Neues Konto anlegen")
            }
                .alert(isPresented: $notify){
                Alert(title: Text(alertTit), message: Text(alertTxt))}.padding()
            if(kontos.count > 0){
                ForEach((0...kontos.count-1), id: \.self){ index in
                    Button(action: {
                        //aktuKonto = Int(kontos[index].id)
                        kontos.forEach{ kontoIndex in
                            if( kontoIndex.id == kontos[index].id ){
                                aktuKonto = kontoIndex
                            }
                        }
                        initCheck = true
                        presentationMode.wrappedValue.dismiss()
                    }){
                        let kontoIban =  kontos[index].iban ?? ""
                        Text("Konto: " + kontoIban)
                    }
                }
            }
        }.navigationBarBackButtonHidden(true)
        Spacer()
    }
}

