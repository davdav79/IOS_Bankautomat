//
//  PinAendern.swift
//  IOS_Bankautomat
//
//  Created by Entwicklung mobiler Applikationen für iOS-Geräte on 21.06.22.
//

import SwiftUI

struct PinAendern: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var Kontos: FetchedResults<Konto>
    @State var useStr : String = ""
    @State var testDone : Bool = false
    @State var notify : Bool = false
    
    func TestNewPin(useStr: String) -> Bool{
        if(useStr.count == 4)
        {
            var pinStrToUse = useStr
            var inputPin : [Int] = []
            for _ in 0...3{
                let element = pinStrToUse.prefix(1)
                let num = Int(element) ?? -1
                if(num == -1){
                    return false
                }
                pinStrToUse.removeFirst()
                inputPin.append(num)
            }
            
            // ToDo: Save new Pin.
            Kontos[0].pin = inputPin
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            notify = true
            presentationMode.wrappedValue.dismiss()
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
            Text("Bitte geben Sie jetzt die neue Pin ein.").frame(width: UIScreen.main.bounds.width/100*80, height: 20).padding()
            Text("\(useStr)").tracking(20).multilineTextAlignment(.center).frame(width: UIScreen.main.bounds.width/100*50, height: 20)
                .padding()
                .border(.black)
                .background(.gray)
                .alert(isPresented: $notify){
                Alert(title: Text("Pin wurde geändert"), message: Text(""))
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
