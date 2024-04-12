//
//  ThemeStore.swift
//  Memorize
//
//  Created by Michelle Staten on 4/3/24.
//

import Foundation
import SwiftUI

// ViewModel

class ThemeStore: ObservableObject, Identifiable, Hashable {
    var name: String
    var id: UUID = .init()
    
    var themes: [Theme] {
        get {
            UserDefaults.standard.themes(forKey: userDefaultsKey)
        }
        set {
            if !newValue.isEmpty {
                UserDefaults.standard.set(newValue, forKey: userDefaultsKey)
                objectWillChange.send()
            }
        }
    }
    
    @Published private var _cursorIndex: Int = 0
    
    // index of currently selected theme
    var cursorIndex: Int {
        get { boundsCheckedThemeIndex(_cursorIndex) }
        set { _cursorIndex = boundsCheckedThemeIndex(newValue) }
    }
    
    // define a specific user defaults key, to prevent storing a key with a generic name like "Main"
    private var userDefaultsKey: String { "ThemeStore: " + name }
    
    init(name: String) {
        self.name = name
        if themes.isEmpty {
            themes = Theme.builtIns
            if themes.isEmpty {
                // give warning if still empty
                themes = [Theme(name: "Warning", rgba: .init(color: .blue), emojis: "⚠️")]
            }
        }
    }
    
    func selectTheme(_ theme: Theme) {
        if let index = themes.firstIndex(where: { $0.id == theme.id }) {
            cursorIndex = index
        }
    }
    
    private func boundsCheckedThemeIndex(_ index: Int) -> Int {
        // make sure index is always within the count's space
        var index = index % themes.count
        if index < 0 {
            index += themes.count
        }
        return index
    }
    
    static func == (lhs: ThemeStore, rhs: ThemeStore) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    // MARK: - Adding Themes to the ThemeStore
    
    // prevent adding the same theme multiple times
    func insert(_ theme: Theme, at insertionIndex: Int? = nil) {
        let insertionIndex = boundsCheckedThemeIndex(insertionIndex ?? cursorIndex)
        if let index = themes.firstIndex(where: { $0.id == theme.id }) {
            themes.move(fromOffsets: IndexSet([index]), toOffset: insertionIndex)
            themes.replaceSubrange(insertionIndex...insertionIndex, with: [theme])
        } else {
            themes.insert(theme, at: insertionIndex)
        }
    }
    
    func insert(name: String, rgba: RGBA, emojis: String, at index: Int? = nil) {
        insert(Theme(name: name, rgba: rgba, emojis: emojis), at: index)
    }
    
}

extension UserDefaults {
    func themes(forKey key: String) -> [Theme] {
        if let jsonData = data(forKey: key),
           let decodedThemes = try? JSONDecoder().decode([Theme].self, from: jsonData) {
            return decodedThemes
        } else {
            return []
        }
    }
    func set(_ themes: [Theme], forKey key: String) {
        let data = try? JSONEncoder().encode(themes)
        set(data, forKey: key)
    }
}
