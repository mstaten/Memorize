//
//  ThemeManager.swift
//  Memorize
//
//  Created by Michelle Staten on 4/4/24.
//

import SwiftUI

struct ThemeManager: View {
    @State var store: ThemeStore
    
    var body: some View {
        EditableThemeList(store: store)
    }
}

struct EditableThemeList: View {
    @State var store: ThemeStore
    
    var body: some View {
        List {
            ForEach(store.themes) { theme in
                NavigationLink(value: theme.id) {
                    VStack(alignment: .leading) {
                        Text(theme.name)
                        Text(theme.emojis.joined(separator: "")).lineLimit(1)
                    }
                }
            }
        }
    }
}

#Preview {
    ThemeManager(store: ThemeStore(name: "Preview"))
}
