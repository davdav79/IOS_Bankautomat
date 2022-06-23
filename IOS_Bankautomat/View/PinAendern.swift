//
//  PinAendern.swift
//  IOS_Bankautomat
//
//  Created by Entwicklung mobiler Applikationen für iOS-Geräte on 21.06.22.
//

import SwiftUI

struct PinAendern: View {
    @State var useStr : String = ""
    @State var testDone : Bool = false
    
    func TestNewPin(useStr: String) -> Bool{
        if(useStr.count == 4)
        {
            var pinStrToUse = useStr
            var inputPin : [Int] = []
            for _ in 0...3{
                let element = pinStrToUse.prefix(1)
                pinStrToUse.removeFirst()
                inputPin.append(Int(element) ?? -1)
            }
            
            // ToDo: Save new Pin.
            return true
        }
        return false
    }
    
    func AppendStr(number:Int, useStr:inout String) -> Void{
        if(useStr.count < 4)
        {
            useStr += "\(number)"
        }
    }
    
    var body: some View {
        VStack{
            Text("Bitte geben Sie jetzt die neue Pin ein.")
            Text("\(useStr)")
            if(testDone)
            {
                Text("Back to main menu wird noch nicht aufgerufen. Save Pin wird auch noch nicht aufgerufen.")
            }
            NumPad(useStr: $useStr, testDone: $testDone, test: TestNewPin, appendStr: AppendStr)
        }
    }
}

struct PinAendern_Previews: PreviewProvider {
    static var previews: some View {
        PinAendern()
    }
}
