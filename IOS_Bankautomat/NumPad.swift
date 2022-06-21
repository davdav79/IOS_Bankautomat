//
//  NumPad.swift
//  IOS_Bankautomat
//
//  Created by Stefan Jessel on 23.06.22.
//

import SwiftUI

struct NumPad: View {
    @Binding var useStr : String
    @Binding var testDone : Bool
    var test: (String) -> Bool
    var appendStr: (Int, inout String) -> Void // Erhalte int und schreibe in den String
    var body: some View {
        VStack{
            HStack(){
                Button(action: {
                    appendStr(1, &useStr);
                }) {
                    Text("1").frame(width: 80, height: 80)
                }.background(.gray)
                    .foregroundColor(.black)
                    .shadow(radius: 5)
                Button(action: {
                    appendStr(2, &useStr);
                }) {
                    Text("2").frame(width: 80, height: 80)
                }.background(.gray)
                    .foregroundColor(.black)
                    .shadow(radius: 5)
                Button(action: {
                    appendStr(3, &useStr);
                }) {
                    Text("3").frame(width: 80, height: 80)
                }.background(.gray)
                    .foregroundColor(.black)
                    .shadow(radius: 5)
            }
            HStack(){
                Button(action: {
                    appendStr(4, &useStr);
                }) {
                    Text("4").frame(width: 80, height: 80)
                }.background(.gray)
                    .foregroundColor(.black)
                    .shadow(radius: 5)
                Button(action: {
                    appendStr(5, &useStr);
                }) {
                    Text("5").frame(width: 80, height: 80)
                }.background(.gray)
                    .foregroundColor(.black)
                    .shadow(radius: 5)
                Button(action: {
                    appendStr(6, &useStr);
                }) {
                    Text("6").frame(width: 80, height: 80)
                }.background(.gray)
                    .foregroundColor(.black)
                    .shadow(radius: 5)
            }
            HStack(){
                Button(action: {
                    appendStr(7, &useStr);
                }) {
                    Text("7").frame(width: 80, height: 80)
                }.background(.gray)
                    .foregroundColor(.black)
                    .shadow(radius: 5)
                Button(action: {
                    appendStr(8, &useStr);
                }) {
                    Text("8").frame(width: 80, height: 80)
                }.background(.gray)
                    .foregroundColor(.black)
                    .shadow(radius: 5)
                Button(action: {
                    appendStr(9, &useStr);
                }) {
                    Text("9").frame(width: 80, height: 80)
                }.background(.gray)
                    .foregroundColor(.black)
                    .shadow(radius: 5)
            }
            HStack(){
                Button(action: {
                    if(useStr.count > 0){
                        useStr.removeLast()}
                }) {
                    Text("C").frame(width: 80, height: 80)
                }.background(.yellow)
                    .foregroundColor(.black)
                    .shadow(radius: 5)
                Button(action: {
                    appendStr(0, &useStr);
                }) {
                    Text("0").frame(width: 80, height: 80)
                }.background(.gray)
                    .foregroundColor(.black)
                    .shadow(radius: 5)
                Button(action: {
                    if(test(useStr))
                    {
                        print("num pad if")
                        testDone = true
                    }
                }) {
                    Text("OK").frame(width: 80, height: 80)
                }.background(.green)
                    .foregroundColor(.black)
                    .shadow(radius: 5)
            }
        }
    }
}

/*
 struct NumPad_Previews: PreviewProvider {
 static var previews: some View {
 NumPad(useStr: Binding<String>, testDone: <#T##Binding<Bool>#>, test: <#T##(String) -> Bool#>, appendStr: <#T##(Int, inout String) -> Void#>)
 }
 }
 */
