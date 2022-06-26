//
//  PinAbfrage.swift
//  IOS_Bankautomat
//
//  Created by Entwicklung mobiler Applikationen für iOS-Geräte on 21.06.22.
//

import SwiftUI

struct PinAbfrage: View{
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var kontos: FetchedResults<Konto>
    
    var nextView: AnyView
    @State var pinInput: String = ""
    @State var next = false
    @State var sperrCnt = 3
    @Binding var aktuKonto:Konto
    
    func TestPin (pinStr:String) -> Bool{
        if(pinStr.count != 4)
        {
            return false
        }
        
        var pinStrToUse = pinStr
        let pin = aktuKonto.pin ?? [0]
        var inputPin : [Int] = []
        for _ in 0...3{
            let element = pinStrToUse.prefix(1)
            pinStrToUse.removeFirst()
            inputPin.append(Int(element) ?? -1)
        }
        
        if(pin == inputPin)
        {
            return true
        }else{
            sperrCnt = sperrCnt - 1
            if(sperrCnt == 0){
                aktuKonto.sperre = true
                presentationMode.wrappedValue.dismiss()
            }
            return false
        }
        
        
        
    }
    
    func AppendStr(number:Int, useStr: inout String) -> Void
    {
        if(useStr.count < 4){
            useStr.append(contentsOf: "\(number)")
        }
    }
    func HideStr(input: String) -> String{
        var output: String = ""
        input.forEach{ _ in
            output.append("*")
        }
        return output
    }
    
    var body: some View {
        VStack{
            if(next){
                nextView
            }else{
                VStack{
                    Text("Bitte Pin eingeben").frame(width: UIScreen.main.bounds.width/100*80, height: 20)
                        .padding()
                        .font(.largeTitle)
                    if(sperrCnt < 3){
                        Text("\(sperrCnt) Versuche übrig").frame(width: UIScreen.main.bounds.width/100*80, height: 20)
                            .padding()
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                    Text("\(HideStr(input:pinInput))").tracking(20).multilineTextAlignment(.center).frame(width: UIScreen.main.bounds.width/100*50, height: 20).padding().border(.black).background(.gray)
                    
                    NumPad(useStr: $pinInput, testDone: $next, test: TestPin, appendStr: AppendStr)
                }
                Spacer()
            }
        }
    }
}
