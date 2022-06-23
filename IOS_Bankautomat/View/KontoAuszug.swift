//
//  KontoAuszug.swift
//  IOS_Bankautomat
//
//  Created by Entwicklung mobiler Applikationen für iOS-Geräte on 21.06.22.
//

import SwiftUI

struct KontoAuszug: View {
    @State var useStr : String = "";
    @State var testDone : Bool = false;
    
    func AppendStr (number:Int, useStr: inout String) -> Void{
        if(useStr.count < 4)
        {
            useStr.append(contentsOf: "\(number)")
            return
        }
        else
        {
            return
        }
    }
    
    func TestStr (useStr:String) -> Bool{
        if (useStr.count == 4)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
    var body: some View {
        VStack{
            Text("Kontoauszug")
            Text("Test: \(useStr)")
            if(testDone)
            {
                Text("Yeah")
            }
            NumPad(useStr: $useStr, testDone: $testDone, test: TestStr, appendStr: AppendStr)
        }
    }
}

struct KontoAuszug_Previews: PreviewProvider {
    static var previews: some View {
        KontoAuszug()
    }
}
