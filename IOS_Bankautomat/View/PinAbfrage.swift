//
//  PinAbfrage.swift
//  IOS_Bankautomat
//
//  Created by Entwicklung mobiler Applikationen für iOS-Geräte on 21.06.22.
//

import SwiftUI

struct PinAbfrage: View{
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var Kontos: FetchedResults<Konto>
    
    var nextView: AnyView
    @State var pinInput: String = ""
    @State var next = false
    
    func TestPin (pinStr:String) -> Bool{
        if(pinStr.count == 4)
        {
            var pinStrToUse = pinStr
            let pin = Kontos[0].pin ?? [0]
            var inputPin : [Int] = []
            for _ in 0...3{
                let element = pinStrToUse.prefix(1)
                pinStrToUse.removeFirst()
                inputPin.append(Int(element) ?? -1)
            }
            
            if(pin == inputPin)
            {
                return true
            }
        }
        return false
    }
    
    func AppendStr(number:Int, useStr: inout String) -> Void
    {
        if(useStr.count < 4){
            useStr.append(contentsOf: "\(number)")
        }
    }
    
    var body: some View {
        VStack{
            if(next){
                nextView
            }else{
                VStack{
                    HStack(){
                        Text("\(pinInput)")
                    }
                    NumPad(useStr: $pinInput, testDone: $next, test: TestPin, appendStr: AppendStr)
                }
            }
        }
    }
}

struct PinAbfrage_Previews: PreviewProvider {
    static var previews: some View {
        PinAbfrage(nextView: AnyView(Auszahlung()))
    }
}
