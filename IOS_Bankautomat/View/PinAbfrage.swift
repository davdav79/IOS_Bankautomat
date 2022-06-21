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
                    if(pinInput.count == 4){
                        Text("\(pinInput[0])\(pinInput[1])\(pinInput[2])\(pinInput[3])")
                    }
                HStack(){
                    Button("1") {
                        if(pinInput.count < 4){
                            pinInput.append(1)
                        }
                            
                    }.padding()
                        .background(.gray)
                        .foregroundColor(.black)
                        .shadow(radius: 5)
                    Button("2") {
                        pinInput.append(2)
                    }.padding()
                        .background(.gray)
                        .foregroundColor(.black)
                        .shadow(radius: 5)
                    Button("3") {
                        pinInput.append(3)
                    }.padding()
                        .background(.gray)
                        .foregroundColor(.black)
                        .shadow(radius: 5)
                    
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
