//
//  NumberNode.swift
//  FreeStyleText
//
//  Created by Hieu Vo on 5/11/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import Foundation
import SpriteKit

class NumberNode : NSObject, NSCoding{
    var column : Int
    var row : Int
    var newColumn = -1
    var newRow = -1
    var number : Int = 0 {
        didSet{
            texture = SKTexture(imageNamed: "Node_Bg_" + String(self.number))
        }
    }
    var mix = false
    var texture : SKTexture
    
    init(column : Int, row : Int, number : Int){
        self.column = column
        self.row = row
        self.number = number
        texture = SKTexture(imageNamed: "Node_Bg_" + String(self.number))
    }    
   
    required convenience init?(coder aDecoder: NSCoder) {
        let column = Int(aDecoder.decodeInt32(forKey: "column"))
        let row = Int(aDecoder.decodeInt32(forKey: "row"))
        let number = Int(aDecoder.decodeInt32(forKey: "number"))
        self.init(column: column, row: row, number: number)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(column, forKey: "column")
        aCoder.encode(row, forKey: "row")
        aCoder.encode(number, forKey: "number")
    }
}
