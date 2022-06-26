//
//  ContentView.swift
//  IOS_Bankautomat
//
//  Created by Stefan Jessel on 16.06.22.
//

import SwiftUI
import CoreData

func FormatGeld(_ stand: Double)->String{
    return String(format: "%@%.2f €", "", stand)
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaktion.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Transaktion>
    @FetchRequest(
        sortDescriptors: [])
    private var kontos: FetchedResults<Konto>
    
    @State var aktuKonto: Konto = Konto()
    @State var isAuszahlungActive : Bool = false
    @State var initCheck:Bool = false
    
    var body: some View {
        if(kontos.count > 0 && initCheck == true) {
            if(kontos[0].sperre == false){
                VStack{
                    NavigationView {
                        List {
                            NavigationLink{
                                PinAbfrage(nextView: AnyView(Auszahlung(aktuKonto: $aktuKonto)), aktuKonto: $aktuKonto)
                            }
                            label: {
                                Text("Auszahlung")
                            }
                            
                            NavigationLink{
                                PinAbfrage(nextView: AnyView(Einzahlung(aktuKonto: $aktuKonto)), aktuKonto: $aktuKonto)
                            } label: {
                                Text("Einzahlung")
                            }
                            NavigationLink{
                                PinAbfrage(nextView: AnyView(Ueberweisung(aktuKonto: $aktuKonto)), aktuKonto: $aktuKonto)
                            } label: {
                                Text("Überweisung")
                            }
                            NavigationLink{
                                PinAbfrage(nextView: AnyView(Kontostand(aktuKonto: $aktuKonto)), aktuKonto: $aktuKonto)
                            } label: {
                                Text("Kontostand")
                            }
                            NavigationLink{
                                PinAbfrage(nextView: AnyView(KontoAuszug(aktuKonto: $aktuKonto)), aktuKonto: $aktuKonto)
                            } label: {
                                Text("Kontoauszug")
                            }
                            NavigationLink{
                                PinAbfrage(nextView: AnyView(PinAendern(aktuKonto: $aktuKonto)), aktuKonto: $aktuKonto)
                            } label: {
                                Text("Pin ändern")
                            }
                            NavigationLink{
                                PinAbfrage(nextView: AnyView(KontoLoeschen(aktuKonto: $aktuKonto)), aktuKonto: $aktuKonto)
                            } label: {
                                Text("Konto Löschen")
                            }
                            NavigationLink{
                                KontoWechsel(aktuKonto: $aktuKonto,initCheck: $initCheck)
                            } label: {
                                Text("Kontowechsel")
                            }
                            
                        }
                    }
                }
                
            }
        }else{
            KontoWechsel(aktuKonto: $aktuKonto, initCheck: $initCheck)
        }
    }
    
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
