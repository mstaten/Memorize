//
//  FlyingNumber.swift
//  Memorize
//
//  Created by Michelle Staten on 10/18/23.
//

import SwiftUI

struct FlyingNumber: View {
    let number: Int
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        if number != 0 {
            Text(number, format: .number.sign(strategy: .always()))
                .font(.largeTitle)
                .foregroundColor(number > 0 ? .green : .red)
                .shadow(
                    color: Constants.Shadow.color,
                    radius: Constants.Shadow.radius,
                    x: Constants.Shadow.x,
                    y: Constants.Shadow.y
                )
                .offset(x: Constants.Offset.x, y: offset)
                .opacity(offset != 0 ? Constants.Opacity.offsetIsNotZero : Constants.Opacity.offsetIsZero)
                .onAppear {
                    withAnimation(.easeIn(duration: Constants.Animation.duration)) {
                        offset = number < 0 ? Constants.Animation.numberIsLessThanZero : Constants.Animation.numberIsGreaterThanZero
                    }
                }
                .onDisappear {
                    offset = 0
                }
        }
    }
    
    private struct Constants {
        struct Shadow {
            static var color: Color = .black
            static var radius: CGFloat = 1.5
            static var x: CGFloat = 1
            static var y: CGFloat = 1
        }
        struct Offset {
            static var x: CGFloat = 0
        }
        struct Opacity {
            static var offsetIsNotZero: CGFloat = 0
            static var offsetIsZero: CGFloat = 1
        }
        struct Animation {
            static var duration: CGFloat = 0.7
            static var numberIsLessThanZero: CGFloat = 200
            static var numberIsGreaterThanZero: CGFloat = -200
        }
    }
}

struct FlyingNumber_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12).foregroundColor(.pink)
            FlyingNumber(number: 2)
        }
    }
}
