//
//  GameViewModel.swift
//  TicTacToe+SwiftUI
//
//  Created by devadmin on 08.11.21.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameDisabled = false
    @Published var alertItem: AlertItem?
    
    func processPlayerMove(for position: Int) {
        if isSquareOccupied(in: moves, forIndex: position) { return }
        moves[position] = Move(player: .human , bordIndex: position)
        
        
        if checkWinCondition(for: .human, in: moves) {
            alertItem = AlertContext.humanWin
            print("human wins")
            return
        }
        
        if checkForDraw(in: moves) {
            alertItem = AlertContext.draw
            print("Draw")
            return
            
        }
        
        isGameDisabled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerPosition = determineComputerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer , bordIndex: computerPosition)
            isGameDisabled = false
            if checkWinCondition(for: .computer, in: moves) {
                alertItem = AlertContext.computerWin
                print("computer wins")
                return
                
            }
            
            if checkForDraw(in: moves) {
                alertItem = AlertContext.draw
                print("Draw")
                return
                
            }
        }
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: {$0?.bordIndex == index})
    }
    
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        // if AI can Win, then win
        let winPatteren : Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }
        let computerPositions = Set(computerMoves.map{$0.bordIndex})
        for pattern in winPatteren {
            let winPosition = pattern.subtracting(computerPositions)
            if winPosition.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPosition.first!)
                if isAvailable {
                    return winPosition.first!
                }
            }
        }
        
        // if AI can't win, then block
        let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }
        let humanPositions = Set(humanMoves.map{$0.bordIndex})
        for pattern in winPatteren {
            let winPosition = pattern.subtracting(humanPositions)
            if winPosition.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPosition.first!)
                if isAvailable {
                    return winPosition.first!
                }
            }
        }
        
        
        // if AI can't block, then take middle square
        let centerSquare = 4
        if !isSquareOccupied(in: moves, forIndex: centerSquare) {
            return centerSquare
        }
        
        // if AI can't take midle squre, take random available square
        var movePosition = Int.random(in: 0..<9)
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatteren : Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map{$0.bordIndex})
        
        for pattern in winPatteren where pattern.isSubset(of: playerPositions) {
            return true
        }
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
}
