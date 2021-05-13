//
//  GameViewModel.swift
//  Tic-Toc
//
//  Created by Sikandar Ali on 14/05/2021.
//

import SwiftUI
final class GameViewModel:ObservableObject{
    
    let colums :[GridItem] = [GridItem(.flexible()),
                              GridItem(.flexible()),
                              GridItem(.flexible()),]
    
    @Published  var moves:[Move?] = Array(repeating: nil, count: 9)
    @Published  var isGameBoardDisabled = false
    @Published  var alertitem:AlertItem?
    func ProcessPlayerMode(in Position:Int){
        if isSqureOccupied(in: moves, firstindex: Position){return}
        moves[Position] = Move(player: .human, boardindex: Position)
    
    //    isHumantrun.toggle()
        //check for win or draw
        if checkWinCondition(for: .human, in: moves ){
           // print("human wins")
            alertitem =  AlertContex.HumanWin
            return
        }
        if checkDraw(in: moves){
           // print("Draw")
            alertitem = AlertContex.Draw
            return
        }
        isGameBoardDisabled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){ [self] in
            let computerpositon = determineComputerMovePosition(in: moves)
            moves[computerpositon] = Move(player: .computer, boardindex: computerpositon)
            isGameBoardDisabled = false
            if checkWinCondition(for: .computer, in: moves ){
               // print("compter wins")
                alertitem = AlertContex.ComputerWin
                return
            }
            if checkDraw(in: moves){
                //print("Draw")
                alertitem = AlertContex.Draw
                return
            }
        }
    }
    
    func isSqureOccupied(in moves:[Move?] , firstindex index:Int)->Bool{
        return moves.contains(where: {$0?.boardindex == index})
    }
    func determineComputerMovePosition(in moves:[Move?])->Int{
        // if ai can win then win
        let winPatteren:Set<Set<Int>> =   [[0,1,2],
                                           [3,4,5],
                                           [6,7,8],
                                           [0,3,6],
                                           [1,4,7],
                                           [2,5,8],
                                           [0,4,8],
                                           [2,4,6]]
        let ComputerMove = moves.compactMap{$0}.filter{$0.player == .computer}
        let ComputerPositon = Set(ComputerMove .map{$0.boardindex})
        for petteren  in winPatteren {
            let winPositions = petteren.subtracting(ComputerPositon)
            if winPositions.count ==  1{
                let isAvailable = !isSqureOccupied(in: moves, firstindex: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
            
        }
        
        // if ai can not win then block
        let HumanMove = moves.compactMap{$0}.filter{$0.player == .human}
        let HumenPositon = Set(HumanMove  .map{$0.boardindex})
        for petteren  in winPatteren {
            let winPositions = petteren.subtracting(HumenPositon)
            if winPositions.count ==  1{
                let isAvailable = !isSqureOccupied(in: moves, firstindex: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
            
        }
        
        // if ai can not bloack then take middle square
        let centerSquare = 4
        if !isSqureOccupied(in: moves, firstindex: centerSquare){
            return centerSquare
        }
        
        
        //if ai can not take middle square then take random square
        var moveposition =  Int.random(in: 0..<9)
       while isSqureOccupied(in: moves, firstindex: moveposition){
         moveposition =  Int.random(in: 0..<9)
        }
        return moveposition
    }
    
    func checkWinCondition(for player:Player, in moves:[Move?])->Bool{
        
        let winPatteren:Set<Set<Int>> =   [[0,1,2],
                                           [3,4,5],
                                           [6,7,8],
                                           [0,3,6],
                                           [1,4,7],
                                           [2,5,8],
                                           [0,4,8],
                                           [2,4,6]]
        let playerMove = moves.compactMap{$0}.filter{$0.player == player}
        let playerPositon = Set(playerMove.map{$0.boardindex})
        
        for peteren in winPatteren where peteren.isSubset(of: playerPositon){ return true}
        
        return false
    }
    func checkDraw(in moves:[Move?])->Bool{
        return moves.compactMap{$0}.count == 9
    }
    func resetGame(){
        moves = Array(repeating: nil, count: 9)
    }
}
