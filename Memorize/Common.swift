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
