//
//  ArrayExtensions.swift
//  PagerView
//
//  Created by Deepak Goyal on 05/08/23.
//

import Foundation

extension Array{
    
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        
        return self[index]
    }
}

extension Array where Element: Hashable{
    
    func unique() -> [Element]{
        var uniqueElements = Set<Element>()
        self.forEach({ uniqueElements.insert($0) })
        return Array(uniqueElements)
    }
}
