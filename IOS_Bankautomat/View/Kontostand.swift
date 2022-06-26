//
//  Kontostand.swift
//  IOS_Bankautomat
//
//  Created by Entwicklung mobiler Applikationen für iOS-Geräte on 21.06.22.
//

import SwiftUI

struct Kontostand: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var Kontos: FetchedResults<Konto>
    @Binding var aktuKonto:Konto
    
    var body: some View {
        VStack{
            Text("Kontostand").padding().font(.largeTitle)
            Text("\(FormatGeld(aktuKonto.stand))")
                .multilineTextAlignment(.center)
                .frame(width: UIScreen.main.bounds.width/100*50, height: 20)
                .padding()
                .border(.black)
                .background(.gray)
            Text("Dispokreditgrenze").padding().font(.title2)
            Text("\(FormatGeld(aktuKonto.dispogrenze))")
                .multilineTextAlignment(.center)
                .frame(width: UIScreen.main.bounds.width/100*50, height: 20)
                .padding()
                .border(.black)
                .background(.gray)
        }
        Spacer()
    }
}
