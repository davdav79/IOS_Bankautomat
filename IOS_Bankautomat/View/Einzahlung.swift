//
//  Einzahlung.swift
//  IOS_Bankautomat
//
//  Created by Entwicklung mobiler Applikationen für iOS-Geräte on 21.06.22.
//

import SwiftUI

struct Einzahlung: View {
    @State var betrag : Int = 0
    var body: some View {
        Text("Einzahlung")
    }
}

struct Einzahlung_Previews: PreviewProvider {
    static var previews: some View {
        Einzahlung()
    }
}
