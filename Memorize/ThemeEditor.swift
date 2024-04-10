//
//  ThemeEditor.swift
//  Memorize
//
//  Created by Michelle Staten on 4/5/24.
//

import SwiftUI

struct ThemeEditor: View {
    @Binding var theme: Theme
    @State private var emojisToAdd: String = ""
    @State private var newColor: Color
    @State private var pairValue: Int
    @State private var pairRange: ClosedRange<Int>
    
    private let emojiFont: Font = .system(size: 40)
    
    init(theme: Binding<Theme>) {
        self._theme = theme
        self.newColor  = Color(rgba: theme.wrappedValue.rgba)
        self.pairRange = theme.wrappedValue.rangeForPairs
        self.pairValue = theme.wrappedValue.numberOfPairs
    }
    
    // MARK: - Views
    
    var body: some View {
        Form {
            nameAndColor
            emojiEditor
            pairStepper
        }
        .navigationTitle(theme.name)
    }
    
    private var nameAndColor: some View {
        Section{
            TextField("Name", text: $theme.name)
            colorPicker
        } header: {
            Text("Name")
        }
    }
    
    private var colorPicker: some View {
        ColorPicker(selection: $newColor, supportsOpacity: true, label: {
            Text("Color")
        })
        .onChange(of: newColor) { newValue in
            theme.rgba = RGBA(color: newValue)
        }
    }
    
    private var emojiEditor: some View {
        Section {
            TextField("Emojis", text: $emojisToAdd)
                .onChange(of: emojisToAdd) { emojisToAdd in
                    addEmojis(emojisToAdd)
                }
            emojiRemover
        } header: {
            Text("Emojis")
        }
    }
    
    private var pairStepper: some View {
        Section {
            Text("\(theme.emojis.count) cards")
            Stepper(value: $pairValue, in: pairRange) {
                Text("\(pairValue) pairs, in range \(pairRange.description)")
            }
            .onChange(of: pairValue) { newValue in
                theme.numberOfPairs = pairValue
            }
        } header: {
            Text("Cards")
        }
    }
    
    private var emojiRemover: some View {
        VStack(alignment: .trailing) {
            Text("Tap to Remove Emojis").font(.caption).foregroundStyle(.gray)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(theme.emojis.uniqued.map(String.init), id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                removeEmoji(emoji)
                            }
                        }
                }
            }
        }
        .font(emojiFont)
    }
    
    // MARK: - Funcs
    
    private func addEmojis(_ emojis: String) {
        theme.emojis = (emojisToAdd + theme.emojis)
            .filter{ $0.isEmoji }
            .uniqued
        updatePairRangeAndValue()
    }
    
    private func removeEmoji(_ emoji: String) {
        theme.emojis.remove(emoji.first!)
        emojisToAdd.remove(emoji.first!)
        updatePairRangeAndValue()
    }
    
    private func updatePairRangeAndValue() {
        pairRange = theme.rangeForPairs
        pairValue = theme.boundsCheckedPairs(pairValue)
    }
}

#Preview {
    struct BindingThemeEditorPreview: View {
        @State private var theme: Theme = Theme.builtIns[0]
        
        var body: some View {
            ThemeEditor(theme: $theme)
        }
    }
    
    return BindingThemeEditorPreview()
}
