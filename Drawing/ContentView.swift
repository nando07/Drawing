//
//  ContentView.swift
//  Drawing
//
//  Created by Fernando Gomez on 2/23/23.
//

import SwiftUI

struct ColorCyclingCircle: View {
    var amount = 0.0
    var steps = 100

    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Circle()
                    .inset(by: Double(value))
                    .strokeBorder(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                color(for: value, brightness: 1),
                                color(for: value, brightness: 0.5)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 2
                    )
            }
        }
        .drawingGroup()
    }

    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(steps) + amount

        if targetHue > 1 {
            targetHue -= 1
        }

        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

//struct Flower: Shape {
//    // How much to move this petal away from the center
//    var petalOffset: Double = -20
//
//    // How wide to make each petal
//    var petalWidth: Double = 100
//
//    func path(in rect: CGRect) -> Path {
//        // The path that will hold all petals
//        var path = Path()
//
//        // Count from 0 up to pi * 2, moving up pi / 8 each time
//        for number in stride(from: 0, to: Double.pi * 2, by: Double.pi / 8) {
//            // rotate the petal by the current value of our loop
//            let rotation = CGAffineTransform(rotationAngle: number)
//
//            // move the petal to be at the center of our view
//            let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))
//
//            // create a path for this petal using our properties plus a fixed Y and height
//            let originalPetal = Path(ellipseIn: CGRect(x: petalOffset, y: 0, width: petalWidth, height: rect.width / 2))
//
//            // apply our rotation/position transformation to the petal
//            let rotatedPetal = originalPetal.applying(position)
//
//            // add it to our main path
//            path.addPath(rotatedPetal)
//
//        }
//
//        // now send the main path back
//        return path
//    }
//}


struct Trapezoid: Shape {
    var insetAmount: Double
    var animatableData: Double {
        get { insetAmount}
        set {insetAmount = newValue}
    }
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: rect.maxY))
               path.addLine(to: CGPoint(x: insetAmount, y: rect.minY))
               path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
               path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
               path.addLine(to: CGPoint(x: 0, y: rect.maxY))

               return path
    }
}

struct Checkerboard: Shape {
    var rows: Int
    var columns: Int

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // figure out how big each row/column needs to be
        let rowSize = rect.height / Double(rows)
        let columnSize = rect.width / Double(columns)

        // loop over all rows and columns, making alternating squares colored
        for row in 0..<rows {
            for column in 0..<columns {
                if (row + column).isMultiple(of: 2) {
                    // this square should be colored; add a rectangle here
                    let startX = columnSize * Double(column)
                    let startY = rowSize * Double(row)

                    let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)
                    path.addRect(rect)
                }
            }
        }

        return path
    }
}

struct ContentView: View {
    @State private var insetAmount = 50.0
    
    var body: some View {
        Trapezoid(insetAmount: insetAmount)
            .frame(width: 200, height: 100)
            .onTapGesture {
                withAnimation {
                    insetAmount = Double.random(in: 10...90)
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
