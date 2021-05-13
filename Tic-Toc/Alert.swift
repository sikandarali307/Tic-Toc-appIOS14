//
//  Alert.swift
//  Tic-Toc
//
//  Created by Sikandar Ali on 14/05/2021.
//

import SwiftUI
struct AlertItem:Identifiable {
    let id = UUID()
    var title:Text
    var message:Text
    var buttontitle:Text
}
struct AlertContex {
    static  let HumanWin = AlertItem(title: Text("You Win"),
                                     message: Text("You Are so Smart"),
                                     buttontitle:Text( "Hell Yeahh"))
    
    static let ComputerWin = AlertItem(title: Text("You Lost"),
                                       message: Text("Your computer have super AI"),
                                       buttontitle:Text( "Hell Yeahh"))
    
    static let Draw       = AlertItem(title: Text("Draw"),
                                      message: Text("what a battle"),
                                      buttontitle:Text( "Try Again"))
}
