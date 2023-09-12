//
//  Dictionary+.swift
//  Metaball
//
//  Created by Eugene Mokhan on 17/08/2022.
//

import Foundation

extension Dictionary {
    subscript(i: Int) -> (key: Key, value: Value) {
        return self[index(startIndex, offsetBy: i)]
    }
}
