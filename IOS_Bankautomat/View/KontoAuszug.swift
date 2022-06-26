//
//  KontoAuszug.swift
//  IOS_Bankautomat
//
//  Created by Entwicklung mobiler Applikationen für iOS-Geräte on 21.06.22.
//

import SwiftUI

struct KontoAuszug: View {
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaktion.timestamp, ascending: true)],
        animation: .default)
    private var transaktionen: FetchedResults<Transaktion>
    @FetchRequest(
        sortDescriptors: [])
    private var kontos: FetchedResults<Konto>
    
    @Binding var aktuKonto:Konto
    private struct Trans: Identifiable {
        let betrag: Double
        let id = UUID()
    }
    
    func FormatDate(_ datum:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm d/M/y"
        return formatter.string(from: datum)
    }
    
    func BuildOutput(tran:Transaktion) -> String{
        var output: String = ""
        output = tran.quelle ?? "Error"
        output += "\n"
        if(tran.zieliban != ""){
            output += "\(tran.zieliban!)\n"
        }
        output += FormatGeld(tran.betrag)
        output += "\n"
        output += FormatDate(tran.timestamp ?? Date.now)
        return output
    }
    var body: some View {
        Text("Kontoauszug").padding().font(.largeTitle)
        List{
            if(transaktionen.count > 0){
                ForEach((1...transaktionen.count), id: \.self){ index in
                    if(transaktionen[transaktionen.count - index].konto == aktuKonto.id){
                        let tmp = transaktionen[transaktionen.count - index]
                        Text(BuildOutput(tran:tmp))
                    }
                }
            }
        }
        Spacer()
    }
}
