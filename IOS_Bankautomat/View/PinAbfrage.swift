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
    
    @State var pinInput: [Int] = []
    var nextView: AnyView
    @State var next = false
    var body: some View {
        VStack{
            if(next){
                nextView
            }else{
                VStack{
                    HStack(){
                        ForEach(pinInput, id: \.self){
                            value in Text("\(value)")
                        }
                    }
                    HStack(){
                        Button(action: {if(pinInput.count < 4){
                            pinInput.append(1)
                        }}) {
                            Text("1").frame(width: 80, height: 80)
                        }.background(.gray)
                            .foregroundColor(.black)
                            .shadow(radius: 5)
                        Button(action: {if(pinInput.count < 4){
                            pinInput.append(2)
                        }}) {
                            Text("2").frame(width: 80, height: 80)
                        }.background(.gray)
                            .foregroundColor(.black)
                            .shadow(radius: 5)
                        Button(action: {if(pinInput.count < 4){
                            pinInput.append(3)
                        }}) {
                            Text("3").frame(width: 80, height: 80)
                        }.background(.gray)
                            .foregroundColor(.black)
                            .shadow(radius: 5)
                    }
                    HStack(){
                        Button(action: {if(pinInput.count < 4){
                            pinInput.append(4)
                        }}) {
                            Text("4").frame(width: 80, height: 80)
                        }.background(.gray)
                            .foregroundColor(.black)
                            .shadow(radius: 5)
                        Button(action: {if(pinInput.count < 4){
                            pinInput.append(5)
                        }}) {
                            Text("5").frame(width: 80, height: 80)
                        }.background(.gray)
                            .foregroundColor(.black)
                            .shadow(radius: 5)
                        Button(action: {if(pinInput.count < 4){
                            pinInput.append(6)
                        }}) {
                            Text("6").frame(width: 80, height: 80)
                        }.background(.gray)
                            .foregroundColor(.black)
                            .shadow(radius: 5)
                    }
                    HStack(){
                        Button(action: {if(pinInput.count < 4){
                            pinInput.append(7)
                        }}) {
                            Text("7").frame(width: 80, height: 80)
                        }.background(.gray)
                            .foregroundColor(.black)
                            .shadow(radius: 5)
                        Button(action: {if(pinInput.count < 4){
                            pinInput.append(8)
                        }}) {
                            Text("8").frame(width: 80, height: 80)
                        }.background(.gray)
                            .foregroundColor(.black)
                            .shadow(radius: 5)
                        Button(action: {if(pinInput.count < 4){
                            pinInput.append(9)
                        }}) {
                            Text("9").frame(width: 80, height: 80)
                        }.background(.gray)
                            .foregroundColor(.black)
                            .shadow(radius: 5)
                    }
                    HStack(){
                        Button(action: {if(pinInput.count > 0){
                            pinInput.removeLast()
                        }}) {
                            Text("C").frame(width: 80, height: 80)
                        }.background(.gray)
                            .foregroundColor(.black)
                            .shadow(radius: 5)
                        Button(action: {if(pinInput.count < 4){
                            pinInput.append(0)
                        }}) {
                            Text("0").frame(width: 80, height: 80)
                        }.background(.gray)
                            .foregroundColor(.black)
                            .shadow(radius: 5)
                        Button(action: {if(pinInput.count == 4){
                            let pin = Kontos[0].pin
                            if (pinInput == (pin ?? [0])){ // Prüfe ob Pin geladen wurde. Vergleiche dann mit eingegebenen PIN
                                self.next = true
                            }
                        }}) {
                            Text("B").frame(width: 80, height: 80)
                        }.background(.gray)
                            .foregroundColor(.black)
                            .shadow(radius: 5)
                            .disabled(pinInput.count != 4)
                    }
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
