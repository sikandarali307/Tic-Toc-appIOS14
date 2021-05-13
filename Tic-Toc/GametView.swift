//
//  ContentView.swift
//  Tic-Toc
//
//  Created by Sikandar Ali on 13/05/2021.
//

import SwiftUI

struct GametView: View {
   @StateObject private var viewModel = GameViewModel()
   
    var body: some View {
        GeometryReader { geo in
            VStack{
                Spacer()
                LazyVGrid(columns:viewModel.colums,spacing: 5) {
                    ForEach(0..<9){ i in
                        ZStack {
                            GameSquareView(proxy: geo)
                            PlayerIndicator(systemImage: viewModel.moves[i]?.indecator ?? "")
                            
                        }
                        .onTapGesture {
                            viewModel.ProcessPlayerMode(in: i)
                        }
                    }
                    
                    }

                Spacer()
            }
            .disabled(viewModel.isGameBoardDisabled)
            .padding()
            .alert(item: $viewModel.alertitem, content: {alertitem in
                Alert(title: alertitem.title, message: alertitem.message, dismissButton:.default(alertitem.buttontitle, action: {viewModel.resetGame()}))
            })
    }
    }
   
}

enum Player {
    case human,computer
}
struct Move {
    let player:Player
    let boardindex:Int
    var indecator : String{
        return player == .human ? "xmark" : "circle"
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GametView()
    }
}

struct GameSquareView: View {
    var proxy :GeometryProxy
    var body: some View {
        Circle()
            .foregroundColor(.red).opacity(0.5)
            .frame(width: proxy.size.width/3-15,
                   height:  proxy.size.width/3-15)
    }
}

struct PlayerIndicator: View {
    var systemImage:String
    var body: some View {
        Image(systemName: systemImage)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
    }
}
