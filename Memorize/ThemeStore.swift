//
//  ThemeStore.swift
//  Memorize
//
//  Created by Michelle Staten on 4/3/24.
//

import Foundation

// ViewModel

class ThemeStore: ObservableObject, Identifiable {
    var name: String
    var id: UUID = .init()
    
    // define a specific user defaults key, to prevent storing a key with a generic name like "Main"
    private var userDefaultsKey: String { "ThemeStore: " + name }
    
    var themes: [Theme] {
        get {
            UserDefaults.standard.themes(forKey: userDefaultsKey)
        }
        set {
            if !newValue.isEmpty {
                UserDefaults.standard.setValue(newValue, forKey: userDefaultsKey)
                objectWillChange.send()
            }
        }
    }
    
    init(name: String) {
        self.name = name
        if themes.isEmpty {
            themes = Theme.builtIns
            if themes.isEmpty {
                // give warning if still empty
                themes = [Theme(name: "Warning", rgba: .init(color: .blue), emojis: ["⚠️"])]
            }
        }
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
