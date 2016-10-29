//
//  Bishop.swift
//  Swifty Chess
//
//  Created by Mikael Mukhsikaroyan on 10/29/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit

class Bishop: ChessPiece {
    
    init(row: Int, column: Int, color: UIColor) {
        
        super.init(row: row, column: column)
        self.color = color
        symbol = "♝"
        
    }
    
}
