//
//  String+Adds.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 29/02/24.
//

import Foundation

extension String {
    public func emptyDefault(_ defaultString: String) -> Self {
        return isEmpty ? defaultString : self
    }
}
