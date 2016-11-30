//
//  BoardIndex.swift
//  Swifty Chess
//
//  Created by Mikael Mukhsikaroyan on 10/31/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit

enum BHorizontal: String {
    case a 
    case b
    case c
    case d
    case e
    case f
    case g
    case h
}

enum BVertical: Int {
    case one = 1 
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
}

enum BDirection {
    case top
    case bottom
}

class BoardIndex: Equatable {
    
    var row: Int!
    var column: Int!
    var valueRow: BVertical!
    var valueCol: BHorizontal!
    
    init(row: Int, column: Int) {
        self.row = row
        self.column = column
        updateValue(fromDirection: .top)
    }
    
    func updateValue(fromDirection dir: BDirection) {

        if dir == .bottom {
            switch row {
            case 0:
                valueRow = .one
            case 1:
                valueRow = .two
            case 2:
                valueRow = .three
            case 3:
                valueRow = .four
            case 4:
                valueRow = .five
            case 5:
                valueRow = .six
            case 6:
                valueRow = .seven
            case 7:
                valueRow = .eight
            default:
                print("SHOULD NOT BE HERE!!")
                valueRow = .eight
            }
            
            switch column {
            case 0:
                valueCol = .a
            case 1:
                valueCol = .b
            case 2:
                valueCol = .c
            case 3:
                valueCol = .d
            case 4:
                valueCol = .e
            case 5:
                valueCol = .f
            case 6:
                valueCol = .g
            case 7:
                valueCol = .h
            default:
                print("SHOULD NOT BE HERE!!!")
                valueCol = .a
            }
        } else if dir == .top {
            switch row {
            case 0:
                valueRow = .eight
            case 1:
                valueRow = .seven
            case 2:
                valueRow = .six
            case 3:
                valueRow = .five
            case 4:
                valueRow = .four
            case 5:
                valueRow = .three
            case 6:
                valueRow = .two
            case 7:
                valueRow = .one
            default:
                print("SHOULD NOT BE HERE!!")
                valueRow = .eight
            }

            switch column {
            case 0:
                valueCol = .a
            case 1:
                valueCol = .b
            case 2:
                valueCol = .c
            case 3:
                valueCol = .d
            case 4:
                valueCol = .e
            case 5:
                valueCol = .f
            case 6:
                valueCol = .g
            case 7:
                valueCol = .h
            default:
                print("SHOULD NOT BE HERE!!!")
                valueCol = .a
            }
        }
    }
    
    static func ==(lhs: BoardIndex, rhs: BoardIndex) -> Bool {
        return lhs.row == rhs.row && lhs.column == rhs.column
    }
    
}
