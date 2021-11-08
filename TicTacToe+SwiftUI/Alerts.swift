//
//  Alerts.swift
//  TicTacToe+SwiftUI
//
//  Created by devadmin on 08.11.21.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    
    static let humanWin = AlertItem(title: Text("You Win"), message: Text("You are smart"), buttonTitle: Text("play again"))
    static let computerWin = AlertItem(title: Text("You lost"), message: Text("Need improvments"), buttonTitle: Text("Restart"))
    static let draw = AlertItem(title: Text("Draw"), message: Text(" need to be smart"), buttonTitle: Text("Try Again"))
}
