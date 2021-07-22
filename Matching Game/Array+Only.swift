//
//  Array+Only.swift
//  Matching Game
//
//  Created by Stanley Moukh on 7/1/21.
//

import Foundation
extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
