//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Michelle Staten on 8/15/23.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var themeStore: ThemeStore = .init(name: "Themes")
    
    var body: some Scene {
        WindowGroup {
            ThemeManager(store: themeStore)
        }
    }
}
