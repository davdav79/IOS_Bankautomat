//
//  AuszahlungIndividuell.swift
//  IOS_Bankautomat
//
//  Created by Entwicklung mobiler Applikationen für iOS-Geräte on 24.06.22.
//

import SwiftUI

struct AuszahlungIndividuell: View {
    @Environment(\.presentationMode) var presentationMode
    var auszahlen: (Double)->Void
    
    @State var betragStr: String = ""
    @State var next = false
    
    @State var alertTxt: String = ""
    @State var alertTit: String = ""
    @State var notify: Bool = false
    
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
        presentationMode.wrappedValue.dismiss()
        auszahlen(Double(betrag))
        presentationMode.wrappedValue.dismiss()
        return true
    }
    var body: some View {
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
            NumPad(useStr: $betragStr, testDone: $next, test: Auszahlen, appendStr: AppendStr)
        }
    }
}
