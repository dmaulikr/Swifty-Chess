//
//  ChessBoard.swift
//  Swifty Chess
//
//  Created by Mikael Mukhsikaroyan on 10/28/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit

class ChessBoard {
    
    var board = [[ChessPiece]]()
    
    init() {
        
        let oneRow = Array(repeating: DummyPiece(row: 0, column: 0), count: 8)
        board = Array(repeating: oneRow, count: 8)
        
        for row in 0...7 {
            for col in 0...7 {
                switch row {
                case 0: // First row of chess board
                    switch col { // determine what piece to put in each column of first row
                    case 0:
                        board[row][col] = Rook(row: row, column: col, color: .white)
                    case 1:
                        board[row][col] = Knight(row: row, column: col, color: .white)
                    case 2:
                        board[row][col] = Bishop(row: row, column: col, color: .white)
                    case 3:
                        board[row][col] = Queen(row: row, column: col, color: .white)
                    case 4:
                        board[row][col] = King(row: row, column: col, color: .white)
                    case 5:
                        board[row][col] = Bishop(row: row, column: col, color: .white)
                    case 6:
                        board[row][col] = Knight(row: row, column: col, color: .white)
                    default:
                        board[row][col] = Rook(row: row, column: col, color: .white)
                    }
                case 1:
                    board[row][col] = Pawn(row: row, column: col, color: .white)
                case 6:
                    board[row][col] = Pawn(row: row, column: col, color: .black)
                case 7:
                    switch col { // determine what piece to put in each column of first row
                    case 0:
                        board[row][col] = Rook(row: row, column: col, color: .black)
                    case 1:
                        board[row][col] = Knight(row: row, column: col, color: .black)
                    case 2:
                        board[row][col] = Bishop(row: row, column: col, color: .black)
                    case 3:
                        board[row][col] = Queen(row: row, column: col, color: .black)
                    case 4:
                        board[row][col] = King(row: row, column: col, color: .black)
                    case 5:
                        board[row][col] = Bishop(row: row, column: col, color: .black)
                    case 6:
                        board[row][col] = Knight(row: row, column: col, color: .black)
                    default:
                        board[row][col] = Rook(row: row, column: col, color: .black)
                    }
                default:
                    board[row][col] = DummyPiece(row: row, column: col)
                }
            }
        }
        //printBoard()
    }
    
    func isAttackingOwnPiece(attackingPiece: ChessPiece, atIndex dest: BoardIndex) -> Bool {
        
        let destPiece = board[dest.row][dest.column]
        guard  !(destPiece is DummyPiece) else {
            // attacking an empty cell
            return false
        }
        
        return destPiece.color == attackingPiece.color
    }
    
    func isMoveLegal(forPiece piece: ChessPiece, toIndex dest: BoardIndex) -> Bool {
        
        // TODO: Possibly a bug. Maybe should be checked before getting here
        if isAttackingOwnPiece(attackingPiece: piece, atIndex: dest) {
            return false 
        }
        
        if piece.col == dest.column && piece.row == dest.row {
            //print("Moving on itself")
            return false
        }
        
//        if !(piece is King) && doesMoveExposeKingToCheck(playerPiece: piece, toIndex: dest) {
//            return false
//        }
        
        switch piece {
        case is Pawn:
            return isMoveValid(forPawn: piece as! Pawn, toIndex: dest)
        case is Rook, is Bishop, is Queen:
            return isMoveValid(forRookOrBishopOrQueen: piece, toIndex: dest)
        case is Knight:
            // The knight doesn't care about the state of the board because
            // it jumps over pieces. So there is no piece in the way for example
            if !(piece as! Knight).isMovementAppropriate(toIndex: dest) {
                return false
            }
        case is King:
            return isMoveValid(forKing: piece as! King, toIndex: dest)
        default:
            break 
        }
        
        return true
    }
    
    func getPossibleMoves(forPiece piece: ChessPiece) -> [BoardIndex] {
        
        var possibleMoves = [BoardIndex]()
        for row in 0...7 {
            for col in 0...7 {
                let dest = BoardIndex(row: row, column: col)
                if isMoveLegal(forPiece: piece, toIndex: dest) {
                    possibleMoves.append(dest)
                }
            }
        }
        
        var realPossibleMoves = [BoardIndex]()
        //print("Checking \(possibleMoves.count) moves")
        for move in possibleMoves {
            //print("BEFORE")
            //printBoard()
            if !doesMoveExposeKingToCheck(playerPiece: piece, toIndex: move) {
                realPossibleMoves.append(move)
            }
            //print("AFTER")
            //printBoard()
        }
        //print("\(realPossibleMoves.count) real moves")
        return realPossibleMoves
    }
    
    func move(chessPiece: ChessPiece, fromIndex source: BoardIndex, toIndex dest: BoardIndex) {
        
        // add piece to new location
        board[dest.row][dest.column] = chessPiece
        // add a dummy piece at old location
        board[source.row][source.column] = DummyPiece(row: source.row, column: source.column)
        // update piece's location variables
        chessPiece.row = dest.row
        chessPiece.col = dest.column
        //printBoard()
    }
    
    // MARK: - Move validations per piece type 
    
    func isMoveValid(forPawn pawn: Pawn, toIndex dest: BoardIndex) -> Bool {
        
        if !pawn.isMovementAppropriate(toIndex: dest) {
            return false
        }
        
        // if it's same column
        if pawn.col == dest.column {
            if pawn.tryingToAdvanceBy2 {
                let moveDirection = pawn.color == .black ? -1 : 1
                
                // make sure there are no pieces in the way or at destination
                if board[dest.row][dest.column] is DummyPiece && board[dest.row - moveDirection][dest.column] is DummyPiece {
                    return true
                }
            } else {
                if board[dest.row][dest.column] is DummyPiece {
                    return true
                }
            }
        } else { // attempting to go diagonally
            // We will check that the destination cell does not contain a friend piece before getting to this cell
            // So just make sure the cell is not empty
            if !(board[dest.row][dest.column] is DummyPiece) {
                return true
            }
        }
        
        return false 
    }
    
    func isMoveValid(forRookOrBishopOrQueen piece: ChessPiece, toIndex dest: BoardIndex) -> Bool {
        
        switch piece {
        case is Rook:
            if !(piece as! Rook).isMovementAppropriate(toIndex: dest) {
                return false
            }
        case is Bishop:
            if !(piece as! Bishop).isMovementAppropriate(toIndex: dest) {
                return false
            }
        case is Queen:
            if !(piece as! Queen).isMovementAppropriate(toIndex: dest) {
                return false
            }
        default:
            // shouldn't be here
            return false
        }
        
        // Diagonal movement for either queen or bishop:
        // *** eg: from index (1,1) to index (3,3) would need to go through (1,1), (2,2), (3,3)
        // Straight movement for either queen or rook:
        // *** eg: from index (1,5) to (1,2) would need to go through (1,5), (1,4), (1,3), (1,2)
        
        // Get the movement directions in both rows and columns
        var rowDelta = 0
        if dest.row - piece.row != 0 {
            // this value will be either -1 or 1 
            rowDelta = (dest.row - piece.row) / abs(dest.row - piece.row)
        }
        var colDelta = 0
        if dest.column - piece.col != 0 {
            colDelta = (dest.column - piece.col) / abs(dest.column - piece.col)
        }
        
        // make sure there are no pieces between itself and the destination cell
        var nextRow = piece.row + rowDelta
        var nextCol = piece.col + colDelta
        while nextRow != dest.row || nextCol != dest.column {
            if !(board[nextRow][nextCol] is DummyPiece) {
                return false
            }
            nextRow += rowDelta
            nextCol += colDelta
        }
        
        return true
    }
    
    func isMoveValid(forKing king: King, toIndex dest: BoardIndex) -> Bool {
        
        if !(king.isMovementAppropriate(toIndex: dest)) {
            return false
        }
        
        if isAnotherKing(atIndex: dest, forKing: king) {
            return false
        }
        
        return true
    }
    
    private func isAnotherKing(atIndex dest: BoardIndex, forKing king: King) -> Bool {
        
        let opponentColor = king.color == UIColor.white ? UIColor.black : UIColor.white
        // Get other king's index
        var otherKingIndex: BoardIndex!
        for row in 0...7 {
            for col in 0...7 {
                if let opponentKing = board[row][col] as? King, opponentKing.color == opponentColor {
                    otherKingIndex = BoardIndex(row: row, column: col)
                    break
                }
            }
        }
        
        // compute absolute difference between the kings
        let rowDiff = abs(otherKingIndex.row - king.row)
        let colDiff = abs(otherKingIndex.column - king.col)
        if (rowDiff == 0 || rowDiff == 1) && (colDiff == 0 || colDiff == 1) {
            return true
        }
        //print("Not near opponent")
        return false
        
    }
    
    /// Returns true if current player is under check, false otherwise
    func isPlayerUnderCheck(playerColor: UIColor) -> Bool {
        
        guard let playerKing = getKing(forColor: playerColor) else {
            print("Something is seriously wrong")
            return false
        }
        
        let opponentColor: UIColor = playerColor == .white ? .black : .white
        
        return isKingUnderUnderCheck(king: playerKing, byOpponent: opponentColor)
    }
    
    private func getKing(forColor color: UIColor) -> King? {
        if color == .white {
            //print("Looking for white king")
        } else if color == .black {
            //print("looking for black king")
        }
        for row in 0...7 {
            for col in 0...7 {
                if let king = board[row][col] as? King, king.color == color {
                    return king
                }
            }
        }
        // should never get here
        print("Did not find king")
        return nil
    }
    
    /// returns true if player's king is under check, false otherwise
    private func isKingUnderUnderCheck(king: King, byOpponent color: UIColor) -> Bool {
        
        let kingIndex = BoardIndex(row: king.row, column: king.col)
        for row in 0...7 {
            for col in 0...7 {
                if board[row][col].color == color {
                    if isMoveLegal(forPiece: board[row][col], toIndex: kingIndex) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    /// Simulates the move and returns true if making it will expose the player to a check
    func doesMoveExposeKingToCheck(playerPiece piece: ChessPiece, toIndex dest: BoardIndex) -> Bool {
        
        // make a copy of the board to simulate movement
//        var boardCopy = getDuplicateBoard()
//        boardCopy[dest.row][dest.column] = piece
//        boardCopy[piece.row][piece.col] = DummyPiece(row: piece.row, column: piece.col)
        let opponent: UIColor = piece.color == UIColor.white ? .black : .white
        //print("Cecking \(piece.color) \(piece.symbol) at [\(piece.row), \(piece.col)] trying to move to [\(dest.row), \(dest.column)")
        if piece.color == .white {
            //print("WHITE")
        } else if piece.color == .black {
            //print("BLACK")
        }
        guard let playerKing = getKing(forColor: piece.color) else {
            print("Something wrong in doesMoveExposeKingToCheck. Logic error")
            return false
        }
        //print("Piece index before: \(piece.row), \(piece.col)")

        
        let kingIndex = BoardIndex(row: playerKing.row, column: playerKing.col)
        //print("King index: \(kingIndex.row), \(kingIndex.column)")
        // can opponent attack own king if player makes this move?
        for row in 0...7 {
            for col in 0...7 {
                
                // "place" piece at the destination it's actually trying to go
                let pieceBeingAttacked = board[dest.row][dest.column]
                board[dest.row][dest.column] = piece
                board[piece.row][piece.col] = DummyPiece(row: piece.row, column: piece.col)
                
                if board[row][col].color == opponent {
                    if isMoveLegal(forPiece: board[row][col], toIndex: kingIndex) {
                        //print("\(board[row][col].symbol) can attack your king!")
                        // undo fake move
                        board[dest.row][dest.column] = pieceBeingAttacked
                        board[piece.row][piece.col] = piece
                        return true
                    }
                }
                
                // undo fake move
                board[dest.row][dest.column] = pieceBeingAttacked
                board[piece.row][piece.col] = piece
            }
        }

        
        //print("Piece index after: \(piece.row), \(piece.col)")
        return false
    }
    
    /*
    private func getDuplicateBoard() -> [[ChessPiece]] {
        var duplicate = [[ChessPiece]]()
        let oneRow = Array(repeating: DummyPiece(row: 0, column: 0), count: 8)
        duplicate = Array(repeating: oneRow, count: 8)
        return duplicate
    }
    */
    
    func printBoard() {
        print(String(repeating: "=", count: 40))
        for row in 0...7 {
            let bRow = board[row].map {$0.symbol}
            print(bRow)
        }
        print(String(repeating: "=", count: 40))
    }
    
    
}


