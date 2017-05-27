//
//  BoardGame.swift
//  FreeStyleText
//
//  Created by Hieu Vo on 5/11/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//
enum moveDirection {
    case left
    case right
    case up
    case down
}

import Foundation
import SpriteKit
import GameplayKit

class BoardGame : NSObject{
    var gameArray = Array2D<NumberNode>(columns : 4, rows :4)
    var score = 0
    var bestScore = 0
    var highestNode = 8
    var gameState : GameState?
    var loadGame = false
    var is2048 = false
    
    override init(){
        super.init()
        setupBoardWithZeroNode()
    }
    
    // save game State
    func saveGameState() {
        if let gameState = gameState {
            gameState.gameArray = gameArray
            gameState.score = score
            gameState.highestNode = highestNode
          //  print(highestNode)
            
        }else{
            gameState = GameState(gameArray: gameArray, score: score, highestNode: highestNode)
        }
        let data = NSKeyedArchiver.archivedData(withRootObject: gameState!)
        UserDefaults.standard.set(data, forKey: "gameState")
    }
    
    //setup board 
    func setupBoardWithZeroNode() {
        for column in 0 ..< 4 {
            for row in 0 ..< 4 {
                gameArray[column,row] = NumberNode(column: column, row: row, number: 0)
            }
        }
    }
    
    //check board is full 
    func isFull() -> Bool {
        for column in 0 ..< 4 {
            for row in 0 ..< 4 {
                let node = gameArray[column, row]
                if node?.number == 0 {
                    return false
                }
            }
        }
        return true
    }
    
    //check all node can move 
    func canMove() -> Bool{
        for column in 0 ..< 4 {
            for row in 0 ..< 4 {
                if let node = gameArray[column, row] {
                    if canNodeMove(node: node) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    //func check Node can move 
    func canNodeMove(node : NumberNode) -> Bool{
        let column = node.column
        let row = node.row
        var countCanMove = 0
        if row + 1 < 4 {
            if let nextNode = gameArray[column, row + 1] {
                if node.number == nextNode.number || nextNode.number == 0 {
                    countCanMove += 1
                }
            }
        }
        
        if row - 1 >= 0 {
            if let nextNode = gameArray[column, row - 1] {
                if node.number == nextNode.number || nextNode.number == 0 {
                    countCanMove += 1
                }
            }
        }
        
        if column + 1 < 4 {
            if let nextNode = gameArray[column + 1, row] {
                if node.number == nextNode.number || nextNode.number == 0 {
                    countCanMove += 1
                }
            }
        }
        
        if column - 1 >= 0 {
            if let nextNode = gameArray[column - 1, row] {
                if node.number == nextNode.number || nextNode.number == 0 {
                    countCanMove += 1
                }
            }
        }
        
        if countCanMove > 0 {
            return true
        }
        return false
    }
    
    func randomNumberNode() -> NumberNode?{
        var flag = false
        var numNode : NumberNode? = nil
        let randomNumberArray = [2,4]
        while !flag {
            let column = Int(arc4random_uniform(4) % 4)
            let row = Int(arc4random_uniform(4) % 4)
          //  print ("Column :\(column) && Row :\(row)")
            let node = gameArray[column,row]
            if node?.number == 0 {
               // numNode = NumberNode(column: column, row: row, number: 2).
                let number = randomNumberArray[Int(arc4random() % 2)]
                numNode = node
                numNode?.number = number
                flag = true
                self.saveGameState()
            }
        }
        return numNode
    }
    
    func swipeBoard(moveDirection : moveDirection) -> ([[NumberNode]],sumScore :Int){
        var rows = [[NumberNode]]()
        var sumScore = 0
        //when swipe is left
        if moveDirection == .left {
            for column in 0 ..< 4 {
                var array = [NumberNode]()
                var mixFlag = false
                var row = 0
                while row < 4 {
                    if let node = gameArray[column,row] {
                        if node.number == 0  {
                            var nextRow = row + 1
                           // print("colum in \(column) & row is \(row) ")
                            while nextRow < 4 {
                                if let nextNode = gameArray[column, nextRow] {
                                    if nextNode.number > 0 {
                                        // kiem tra xem node ben trai co cung so ko? new u co thi sea mix lai
                                        if row >= 1 && !mixFlag {
                                            let previousNode = gameArray[column, row - 1]//
                                            if let nodeMix = self.mix2Node(node: nextNode, mixIntoNode: previousNode!){
                                                mixFlag = true
                                                sumScore += previousNode!.number
                                                array.append(nodeMix)
                                                row -= 2
                                                break
                                            }
                                        }
                                            // neu khong cung thi se move ve vi tri sat ben
                                            nextNode.newRow = row
                                            nextNode.newColumn = column
                                            node.number = nextNode.number
                                            nextNode.number = 0
                                            array.append(nextNode)
                                        break
                                    }
                                }
                                nextRow += 1
                            }
                            // check o row do co mix chua va so sanh 2 o sat ben trai
                        } else if !mixFlag && row >= 1 {
                            let node = gameArray[column, row]
                            let previousNode = gameArray[column, row - 1]//
                            if let nodeMix = self.mix2Node(node: node!, mixIntoNode: previousNode!) {
                                mixFlag = true
                                array.append(nodeMix)
                                sumScore += previousNode!.number
                                row -= 2
                            }
                        }
                    }
                    row += 1
                }
                if !array.isEmpty {
                    rows.append(array)
                }
            }
        }
        
        
        //when swipe is right
        if moveDirection == .right {
            for column in 0 ..< 4 {
                var array = [NumberNode]()
                var mixFlag = false
                var row = 3
                
                while row >= 0 {
                    if let node = gameArray[column,row] {
                        if node.number == 0  {
                            var nextRow = row - 1
                            // kiem tra node ke node number = 0
                            while nextRow > -1 {
                                if let nextNode = gameArray[column, nextRow] {
                                    // neu phat hien ra node co number khac 0 thi se move ve vi tri number = 0
                                    if nextNode.number > 0 {
                                        // kiem tra khi move ve node sat ben fai va kiem tra
                                        if !mixFlag && row <= 2 {
                                            if let nextByNode = gameArray[column, row + 1]{
                                                if let mixNode = self.mix2Node(node: nextNode, mixIntoNode: nextByNode){
                                                    mixFlag = true
                                                    array.append(mixNode)
                                                    sumScore += nextByNode.number
                                                    row += 2
                                                    break
                                                }
                                            }
                                        }
                                            nextNode.newRow = row //+ moreNode
                                            nextNode.newColumn = column
                                            node.number = nextNode.number
                                            nextNode.number = 0
                                            array.append(nextNode)
                                          //  print("column is \(column) & new row is \(nextRow)")
                                        break
                                    }
                                }
                                nextRow -= 1
                            }
                        } else if !mixFlag && row <= 2 {
                          //  let node = gameArray[column, row]
                            let nextNode = gameArray[column, row + 1]
                            if let nodeMix = self.mix2Node(node: node, mixIntoNode: nextNode!) {
                                mixFlag = true
                                array.append(nodeMix)
                                row += 2
                                sumScore += nextNode!.number
                            }
                        }
                    }
                    row -= 1
                }
                if !array.isEmpty {
                    rows.append(array)
                }
            }
        }
        
        //when swipe is up
        if moveDirection == .up {
            for row in 0 ..< 4 {
                var array = [NumberNode]()
                var mixFlag = false
                var column = 3
                while column >= 0 {
                    if let node = gameArray[column,row] {
                        if node.number == 0  {
                           // print("colum in \(column) & row is \(row) ")
                            var nextColumn = column - 1
                            while nextColumn > -1{
                                if let nextNode = gameArray[nextColumn,row] {
                                    if nextNode.number > 0 {
                                        if !mixFlag && column <= 2 {
                                            if let nextByNode = gameArray[column + 1, row] {
                                                if let mixNode = self.mix2Node(node: nextNode, mixIntoNode: nextByNode){
                                                    mixFlag = true
                                                    array.append(mixNode)
                                                    sumScore += nextByNode.number
                                                    column += 2
                                                    break
                                                }
                                            }
                                        }
                                        nextNode.newRow = row
                                        nextNode.newColumn = column
                                        node.number = nextNode.number
                                        nextNode.number = 0
                                        array.append(nextNode)
                                     //   print("column is \(nextColumn) & new row is \(row)")
                                        break
                                    }
                                }
                                nextColumn -= 1
                            }
                        } else if !mixFlag && column <= 2 {
                            let nextNode = gameArray[column + 1, row]
                            if let mixNode = self.mix2Node(node: node, mixIntoNode: nextNode!) {
                                mixFlag = true
                                array.append(mixNode)
                                sumScore += nextNode!.number
                                column += 2
                            }
                        }
                    }
                    column -= 1
                }
                if !array.isEmpty {
                    rows.append(array)
                }
            }
        }
        
        // when swipe is down
        if moveDirection == .down {
            for row in 0 ..< 4 {
                var array = [NumberNode]()
                var mixFlag = false
                var column = 0
                while column < 4 {
                    if let node = gameArray[column,row] {
                        if node.number == 0  {
                           // print("colum in \(column) & row is \(row) ")
                            for nextColumn in (column + 1) ..< 4{
                                if let nextNode = gameArray[nextColumn, row] {
                                    if nextNode.number > 0 {
                                        if !mixFlag && column >= 1 {
                                            if let nextByNode = gameArray[column - 1, row] {
                                                if let mixNode = self.mix2Node(node: nextNode, mixIntoNode: nextByNode){
                                                    mixFlag = true
                                                    array.append(mixNode)
                                                    sumScore += nextByNode.number
                                                    column -= 2
                                                    break
                                                }
                                            }
                                        }
                                        nextNode.newRow = row
                                        nextNode.newColumn = column
                                        node.number = nextNode.number
                                        nextNode.number = 0
                                        array.append(nextNode)
                                        
                                       // print("column is \(nextColumn) & new row is \(row)")
                                        break
                                    }
                                }
                            }
                        } else if !mixFlag && column >= 1 {
                            if let downNode = gameArray[column - 1 , row] {
                                if let mixNode = self.mix2Node(node: node, mixIntoNode: downNode){
                                    mixFlag = true
                                    array.append(mixNode)
                                    column -= 2
                                    sumScore += downNode.number
                                }
                            }
                        }
                        
                    }
                    column += 1
                }
                if !array.isEmpty {
                    rows.append(array)
                }
            }
        }
        score += sumScore
        bestScore = max(score, bestScore)
        return (rows,sumScore)
    }
    
    // Khi mix 2 node giong nhau
    func mix2Node(node : NumberNode, mixIntoNode: NumberNode) -> NumberNode? {
        if node.number == mixIntoNode.number {
            node.newRow = mixIntoNode.row
            node.newColumn = mixIntoNode.column
            node.number = 0
            mixIntoNode.number = mixIntoNode.number * 2
            if mixIntoNode.number == 2048 {
                is2048 = true
            }
            highestNode = max(highestNode, mixIntoNode.number * 2)
            node.mix = true
            return node
        }
        return nil
    }
    
    func printArray(){
        for column in (0 ..< 4).reversed() {
            for row in 0 ..< 4 {
                let node = gameArray[column,row]
                print(node!.number, terminator : " ")
            }
            print()
        }
    }
    
    func processAIEasy() -> moveDirection? {
        var arrayDirection = [moveDirection]()
        var direction : moveDirection? = nil
        let copyBoard = BoardGame()
        var maxScore = 0
        
        copyArray(array: gameArray, arrayCopy: copyBoard.gameArray)
        //letf
        let (arrayleft , scoreLeft) = copyBoard.swipeBoard(moveDirection: .left)
        if arrayleft.count > 0 {
            if direction == nil {
                direction = .left
            }
            if scoreLeft > maxScore {
                direction = .left
                maxScore = scoreLeft
            }else if scoreLeft == maxScore {
                arrayDirection.append(.left)
            }
        }
        //right
        copyArray(array: gameArray, arrayCopy: copyBoard.gameArray)
        let (arrayRight, scoreRight) = copyBoard.swipeBoard(moveDirection: .right)
        if arrayRight.count > 0{
            if direction == nil {
                direction = .right
            }
            if scoreRight > maxScore {
                direction = .right
                maxScore = scoreRight
                arrayDirection.removeAll()
            }else if scoreRight == maxScore{
                arrayDirection.append(.right)
            }
            
        }
        //up
        copyArray(array: gameArray, arrayCopy: copyBoard.gameArray)
        let (arrayUp, scoreUp) = copyBoard.swipeBoard(moveDirection: .up)
        if arrayUp.count > 0{
            if direction == nil {
                direction = .up
            }
            if scoreUp > maxScore {
                direction = .up
                maxScore = scoreUp
                arrayDirection.removeAll()
            }else if scoreUp == maxScore {
                arrayDirection.append(.up)
            }
        }
        //down
        copyArray(array: gameArray, arrayCopy: copyBoard.gameArray)
        let (arrayDown, scoreDown) = copyBoard.swipeBoard(moveDirection: .down)
        if arrayDown.count > 0 {
            if direction == nil {
                direction = .down
            }
            if scoreDown > maxScore {
                direction = .down
                maxScore = scoreDown
                arrayDirection.removeAll()
            } else if scoreDown == maxScore {
                arrayDirection.append(.down)
            }
        }
        
        if !arrayDirection.isEmpty {
            let randomIndex = Int(arc4random_uniform(UInt32(arrayDirection.count - 1)))
            return arrayDirection[randomIndex]
        }
        return direction
    }
    
    func processAI() -> moveDirection? {
        var arrayDirection = [moveDirection]()
        var direction : moveDirection? = nil
        let copyBoard = BoardGame()
        let secondCopyBoard = BoardGame()
        var maxScore = 0
        var playerScore = 0
        var diffScore = 0
        copyArray(array: gameArray, arrayCopy: copyBoard.gameArray)
        //letf
        let (arrayleft , scoreLeft) = copyBoard.swipeBoard(moveDirection: .left)
        if arrayleft.count > 0 {
            if direction == nil {
                direction = .left
            }
            copyArray(array: copyBoard.gameArray, arrayCopy: secondCopyBoard.gameArray)
            playerScore = secondCopyBoard.findBestScore()
            diffScore = scoreLeft - playerScore
            if diffScore > maxScore {
                direction = .left
                maxScore = diffScore
            }else if diffScore == maxScore {
                arrayDirection.append(.left)
            }
            //print("diff Left : \(diffScore)")
            //print("array Left : \(arrayleft.count)")
        }
        //right
        
        copyArray(array: gameArray, arrayCopy: copyBoard.gameArray)
        let (arrayRight, scoreRight) = copyBoard.swipeBoard(moveDirection: .right)
        if arrayRight.count > 0{
            if direction == nil {
                direction = .right
            }
            copyArray(array: copyBoard.gameArray, arrayCopy: secondCopyBoard.gameArray)
            playerScore = secondCopyBoard.findBestScore()
            diffScore = scoreRight - playerScore
            if diffScore > maxScore {
                direction = .right
                maxScore = diffScore
                arrayDirection.removeAll()
            }else if diffScore == maxScore{
                arrayDirection.append(.right)
            }
           // print("diff right : \(diffScore)")
           // print("arrayRight : \(arrayRight.count)")
        }
        
        //up
        copyArray(array: gameArray, arrayCopy: copyBoard.gameArray)
        let (arrayUp, scoreUp) = copyBoard.swipeBoard(moveDirection: .up)
        if arrayUp.count > 0 {
            if direction == nil {
                direction = .up
            }
            copyArray(array: copyBoard.gameArray, arrayCopy: secondCopyBoard.gameArray)
            playerScore = secondCopyBoard.findBestScore()
            diffScore = scoreUp - playerScore
            if diffScore > maxScore {
                direction = .up
                maxScore = diffScore
                arrayDirection.removeAll()
            }else if diffScore == maxScore {
                arrayDirection.append(.up)
            }
          //  print("diff up : \(diffScore)")
           // print("arrayUp : \(arrayUp.count)")
        }
        
        //down
        copyArray(array: gameArray, arrayCopy: copyBoard.gameArray)
        let (arrayDown, scoreDown) = copyBoard.swipeBoard(moveDirection: .down)
        if arrayDown.count > 0 {
            if direction == nil {
                direction = .down
            }
            copyArray(array: copyBoard.gameArray, arrayCopy: secondCopyBoard.gameArray)
            playerScore = secondCopyBoard.findBestScore()
            diffScore = scoreDown - playerScore
            if diffScore > maxScore {
                direction = .down
                maxScore = diffScore
                arrayDirection.removeAll()
            } else if maxScore == diffScore {
                arrayDirection.append(.down)
            }
           // print("diff down : \(diffScore)")
          //  print("arrayDown :\(arrayDown.count)")
        }
        print("------------")
        
        if !arrayDirection.isEmpty {
            let randomIndex = Int(arc4random_uniform(UInt32(arrayDirection.count - 1)))
            return arrayDirection[randomIndex]
        }        
        return direction
        
    }
    
    // Ham dung de copy value cua mang
    func copyArray(array : Array2D<NumberNode>, arrayCopy : Array2D<NumberNode>){
        for column in 0 ..< array.columns {
            for row in 0 ..< array.rows {
                arrayCopy[column,row]?.number = (array[column, row]?.number)!
            }
        }
    }

    func findBestScore() -> Int{
        var maxScore = 0
        let copyBoard = BoardGame()
        copyArray(array: gameArray, arrayCopy: copyBoard.gameArray)
        let (_ , scoreLeft) = copyBoard.swipeBoard(moveDirection: .left)
        if scoreLeft >= maxScore {
            maxScore = scoreLeft
        }
        copyArray(array: gameArray, arrayCopy: copyBoard.gameArray)
        let (_, scoreRight) = copyBoard.swipeBoard(moveDirection: .right)
        if scoreRight >= maxScore {
            maxScore = scoreRight
        }
        copyArray(array: gameArray, arrayCopy: copyBoard.gameArray)
        let (_, scoreUp) = copyBoard.swipeBoard(moveDirection: .up)
        if scoreUp >= maxScore {
            maxScore = scoreUp
        }
        copyArray(array: gameArray, arrayCopy: copyBoard.gameArray)
        let (_, scoreDown) = copyBoard.swipeBoard(moveDirection: .down)
        if scoreDown >= maxScore {
            maxScore = scoreDown
        }
        return maxScore
    }
    
}

