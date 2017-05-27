//
//  GameState.swift
//  FreeStyleText
//
//  Created by Hieu Vo on 5/17/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import Foundation

class GameState : NSObject, NSCoding {
    var gameArray : Array2D<NumberNode>
    var score : Int
    var highestNode : Int
    
    init(gameArray : Array2D<NumberNode>, score : Int , highestNode : Int) {
        self.gameArray = gameArray
        self.score = score
        self.highestNode = highestNode
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let nodeArray = aDecoder.decodeObject(forKey: "arrayNodes") as? [NumberNode] else {
            return nil
        }
        var gameArray = Array2D<NumberNode>.init(columns: 4, rows: 4)
        for node in nodeArray {
            gameArray[node.column, node.row] = node
        }
        let score = Int(aDecoder.decodeInt32(forKey: "score"))
        let highestNode = Int(aDecoder.decodeInt32(forKey: "highestNode"))
        self.init(gameArray: gameArray, score: score, highestNode: highestNode)
        
    }
    
    func encode(with aCoder: NSCoder) {    
        let arrayNumberNode = convertGameArrayToArray(gameArray: gameArray)
        aCoder.encode(arrayNumberNode, forKey: "arrayNodes")
        aCoder.encode(score, forKey: "score")
        aCoder.encode(highestNode, forKey: "highestNode")
        print(highestNode)
    }
    
    func convertGameArrayToArray(gameArray : Array2D<NumberNode>) -> [NumberNode]{
        var arrayNumberNoder = [NumberNode]()
        for column in 0 ..< gameArray.columns{
            for row in 0 ..< gameArray.rows {
                if let numberNode = gameArray[column, row]{
                    if numberNode.number > 0 {
                        arrayNumberNoder.append(numberNode)
                    }
                }
            }
        }
        return arrayNumberNoder
    }
    
    func covertArrayToGameArray(_: [NumberNode]) -> Array2D<NumberNode> {
        let gameArray = Array2D<NumberNode>.init(columns: 4, rows: 4)
        return gameArray
    }
}
