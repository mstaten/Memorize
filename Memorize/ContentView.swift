//
//  ContentView.swift
//  Memorize
//
//  Created by Michelle Staten on 8/15/23.
//

import SwiftUI

// Lesson 1: "behaves like a..." vs "is a..."
/// this is functional programming. The focus is on the functionality, the behavior, and not on the data.
/// OOP - its roots are data encapsulation.
/// Functional prog. is more like behavior encapsulation, but much more. it's all about behavior - how do things behave, how do structs behave...
// "This struct, ContentView, behaves like a View"
// difference is that View is not a struct, it's a protocol - a thing you can behave like
struct ContentView: View {
    
    // "This variable, i, is of type Int"
    
    // normal properties, stored properties (not really a proper name)
//    var i: Int
//    var s: String
    
    // computed property
    
    // computed: the value of this variale is not stored somewhere; it's computed.
    // every time it's asked for, it's computed. It's running a lot.
    // it's like a read-only variable because you can only compute the value
    
    // the type of this variable can be any struct in the world as long as it behaves like a View
    var body: some View {
        HStack {
            CardView()
            CardView(isFaceUp: true)
            CardView()
            CardView()
        }
        .foregroundColor(.orange)
        .padding()
    }
}

struct CardView: View {
    var isFaceUp: Bool = false
    
    var body: some View {
        if isFaceUp {
            ZStack {
                RoundedRectangle(cornerRadius: 12).foregroundColor(.white)
                RoundedRectangle(cornerRadius: 12).strokeBorder(lineWidth: 2)
                Text("👻").font(.largeTitle)
            }
        } else {
            RoundedRectangle(cornerRadius: 12)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
