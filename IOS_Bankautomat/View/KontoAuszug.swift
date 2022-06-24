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
    
    private struct Trans: Identifiable {
        let betrag: Double
        let id = UUID()
    }
    
    func FormatDate(_ datum:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm d/M/y"
        return formatter.string(from: datum)
    }
    
    var body: some View {
        VStack{
            List{
                ForEach((0..<transaktionen.count), id: \.self){ index in
                    let tmp = transaktionen[index]
                    //let time = (tmp.zieliban == nil ? "" : tmp.zieliban + "\n")
                    var time: String = ""
                    if(tmp.zieliban != nil){
                        time = "\(tmp.zieliban)\n"
                    }
                    Text((tmp.quelle ?? "Error") + "\n" + FormatGeld(tmp.betrag) + time + "\n" + FormatDate(Date.now))
                    
                }
            }
        }
    }
}

struct KontoAuszug_Previews: PreviewProvider {
    static var previews: some View {
        KontoAuszug()
    }
}
