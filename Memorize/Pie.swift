//
//  Pie.swift
//  Memorize
//
//  Created by Michelle Staten on 10/11/23.
//

import SwiftUI
import CoreGraphics

// important to note: iOS doesn't use Cartesian coordinates.
// iOS has an upper-left convention of origin.
struct Pie: Shape, InsettableShape {
    
    var insetAmount: CGFloat = 0
    
    var startAngle: Angle = .zero
    let endAngle: Angle
    var clockwise: Bool = true
    
    func path(in rect: CGRect) -> Path {
        let startAngle = startAngle - .degrees(90)
        let endAngle = endAngle - .degrees(90)
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        // x = r(cos(degrees‎°)), y = r(sin(degrees‎°))
        let start = CGPoint(
            x: center.x + radius * cos(startAngle.radians),
            y: center.y + radius * sin(startAngle.radians)
        )
        
        var p = Path()
        
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: !clockwise)
        p.addLine(to: center)
        
        return p
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var pie = self
        pie.insetAmount = insetAmount
        return pie
    }
}
