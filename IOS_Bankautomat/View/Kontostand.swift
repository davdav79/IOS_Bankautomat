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
            Text("\(Kontos[0].stand)")
        }
    }
}

struct Kontostand_Previews: PreviewProvider {
    static var previews: some View {
        Kontostand()
    }
}
