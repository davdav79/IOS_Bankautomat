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
    @State var notify:Bool = false
    
    @Binding var aktuKonto:Konto
    @Binding var kontoCheck:Bool
    
    func NeuesKonto(){
        let newItem = Konto(context: viewContext)
        newItem.pin = [Int.random(in: 0...9),Int.random(in: 0...9),Int.random(in: 0...9),Int.random(in: 0...9)]//[1,1,1,1]
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
        
        alertTit = "Konto erstellt"
        alertTxt = "IBAN: " + newItem.iban! + "\n PIN: "
        for num in newItem.pin!{
            alertTxt += String(num)
        }
        notify = true
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaktion.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Transaktion>
    
    func UnlockAll(){
        kontos.forEach{konto in konto.sperre = false}
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func DeleteAll(){
        kontos.forEach{ konto in viewContext.delete(konto)}
        items.forEach{item in viewContext.delete(item)}
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    var body: some View {
        Text("Kontowechsel").padding().font(.largeTitle)
        Button(action: NeuesKonto) {
            Text("Neues Konto anlegen").frame(width: UIScreen.main.bounds.width/100*80, height: UIScreen.main.bounds.width/100*15)
        }.background(.gray)
            .foregroundColor(.black)
            .shadow(radius: 5)
            .alert(isPresented: $notify){
                Alert(title: Text(alertTit), message: Text(alertTxt))}.padding()
        List{
            if(kontos.count > 0){
                ForEach((0...kontos.count-1), id: \.self){ index in
                    let locked = kontos[index].sperre
                    Button(action: {
                        //aktuKonto = Int(kontos[index].id)
                        kontos.forEach{ kontoIndex in
                            if( kontoIndex.id == kontos[index].id ){
                                aktuKonto = kontoIndex
                            }
                        }
                        kontoCheck = true
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        let kontoIban =  kontos[index].iban ?? ""
                        Text("Konto: " + kontoIban).frame(width: UIScreen.main.bounds.width/100*80, height: UIScreen.main.bounds.width/100*15)
                    }.background(locked ? .red : .gray)
                        .foregroundColor(.black)
                        .shadow(radius: 5)
                        .disabled(locked)
                }
            }
        }.navigationBarBackButtonHidden(true)
        
        if(!kontoCheck && !kontos.isEmpty){
            Button(action: UnlockAll) {
                Text("Kontos entsperren").frame(width: UIScreen.main.bounds.width/100*80, height: UIScreen.main.bounds.width/100*15)
            }.background(.gray)
                .foregroundColor(.black)
                .shadow(radius: 5)
                .alert(isPresented: $notify){
                    Alert(title: Text(alertTit), message: Text(alertTxt))}.padding()
            Button(action: DeleteAll) {
                Text("Kontos löschen").frame(width: UIScreen.main.bounds.width/100*80, height: UIScreen.main.bounds.width/100*15)
            }.background(.gray)
                .foregroundColor(.black)
                .shadow(radius: 5)
                .alert(isPresented: $notify){
                    Alert(title: Text(alertTit), message: Text(alertTxt))}.padding()
        }
        Spacer()
    }
}

