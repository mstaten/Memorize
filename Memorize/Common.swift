//
//  Common.swift
//  Memorize
//
//  Created by Michelle Staten on 9/8/23.
//

import UIKit

// MARK: - Device size
let DEVICE_WIDTH = UIScreen.main.bounds.width // swiftlint:disable:this identifier_name
let DEVICE_HEIGHT = UIScreen.main.bounds.height // swiftlint:disable:this identifier_name

extension Array {
    var only: Element? {
        self.count == 1 ? self.first : nil
    }
}

//struct MemoryGame<CardContent> where CardContent: Equatable {
//extension Array where Element: Identifiable {
//    func whereIdMatches(id: ObjectIdentifier) -> Int? {
//        return firstIndex(where: { $0.id == id })
//    }
//}
