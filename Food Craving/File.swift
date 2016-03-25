//
//  File.swift
//  Food Craving
//
//  Created by Ross Duris on 3/25/16.
//  Copyright © 2016 duris.io. All rights reserved.
//

import Foundation

extension RangeReplaceableCollectionType where Generator.Element : Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(object : Generator.Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}