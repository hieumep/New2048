//
//  Array2D.swift
//  FreeStyleText
//
//  Created by Hieu Vo on 5/11/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import Foundation

import Foundation

// tao mang 2 chieu
struct Array2D<T> {
    let columns : Int
    let rows : Int
    fileprivate var array : Array<T?>
    
    init(columns : Int, rows : Int){
        self.columns = columns
        self.rows = rows
        array = Array<T?>(repeating : nil, count : columns * rows)
    }
    
    subscript(column : Int, row : Int) -> T? {
        get {
            return array[columns * row + column]
        }
        set {
            array[columns * row + column] = newValue
        }
    }   
   
}
