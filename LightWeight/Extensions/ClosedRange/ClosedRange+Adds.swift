//
//  ClosedRange+Adds.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 27/02/24.
//

import Foundation

extension ClosedRange<Int> {
    
    static func affectedItems(from source: IndexSet, to destination: Int) -> ClosedRange<Int>? {
        guard let sourceStart = source.first, let sourceEnd = source.last else { return nil }
        
        let offset = destination - sourceStart
        
        guard offset != 0 else { return nil }
        
        let startIndex: Int = offset > 0 ? sourceStart : sourceStart + offset
        let endIndex: Int = offset > 0 ? sourceEnd + offset : sourceEnd
        
        return startIndex...endIndex
    }
    
}
