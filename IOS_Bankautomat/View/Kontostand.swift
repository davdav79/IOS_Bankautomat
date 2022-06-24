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
    
    var body: some View {
        VStack{
            Text("Kontostand")
            Text("\(FormatGeld(Kontos[0].stand))")
                .multilineTextAlignment(.center)
                .frame(width: UIScreen.main.bounds.width/100*50, height: 20)
                .padding()
                .border(.black)
                .background(.gray)
            Text("Dispokreditgrenze")
            Text("\(FormatGeld(Kontos[0].dispogrenze))")
                .multilineTextAlignment(.center)
                .frame(width: UIScreen.main.bounds.width/100*50, height: 20)
                .padding()
                .border(.black)
                .background(.gray)
        }
    }
}

struct Kontostand_Previews: PreviewProvider {
    static var previews: some View {
        Kontostand()
    }
}
