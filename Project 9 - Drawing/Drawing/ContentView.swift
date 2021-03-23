//
//  ContentView.swift
//  Drawing
//
//  Created by Tiberiu on 09.02.2021.
//

import SwiftUI

struct ContentView: View {
    //challenge 2
    @State private var thickness: CGFloat = 5
    //Challenge 3
    @State private var amount: Double = 1


    var body: some View {
        VStack(spacing: 10) {
            ColorCyclingRectangle(amount: amount)
            Slider(value: $amount)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Trapezoid: Shape {
    var insetAmount: CGFloat
    
    var animatableData: CGFloat {
        get { insetAmount }
        set { self.insetAmount = newValue }
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

struct Arc: InsettableShape {
    
    var startAngle: Angle
    var endAngle: Angle
    var clockWise: Bool
    
    var insetAmount: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment
        
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2 - insetAmount, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockWise)
        
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        
        arc.insetAmount += amount
        return arc
    }
}

struct Flower: Shape {
    //How much to move the petal away from the center
    var petalOffset: Double = -20
    //How wide to make each petal
    var petalWidth: Double = 100
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        //Count from 0 up to pi * 2, moving up pi/8 each time
        
        for number in stride(from: 0, to: CGFloat.pi * 2, by: CGFloat.pi / 8) {
            //rotate the petal by the current value of our loop
            let rotation = CGAffineTransform(rotationAngle: number)
            
            //move the petal to be at the center of our view
            let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))
            
            //create a path for this petal using our proprties plus a fixed Y and height
            let originalPetal = Path(ellipseIn: CGRect(x: CGFloat(petalOffset), y: 0, width: CGFloat(petalWidth), height: rect.width / 2))
            
            //apply our rotation/position transformation to the petal
            let rotatedPetal = originalPetal.applying(position)
            
            //add it to our main path
            path.addPath(rotatedPetal)
        }
        
        //now send the main path back
        return path
    }
}

struct ColorCyclingCircle: View {
    var amount = 0.0
    var steps = 100
    
    var body: some View {
        ZStack {
            ForEach(0 ..< steps) { value in
                Circle()
                    .inset(by: CGFloat(value))
                    .strokeBorder(LinearGradient(gradient: Gradient(colors: [
                        self.color(for: value, brightness: 1),
                        self.color(for: value, brightness: 0.5)
                    ]), startPoint: .top, endPoint: .bottom), lineWidth: 2)
            }
        }
        .drawingGroup()
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps) + self.amount
        
        if targetHue > 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct Checkerboard: Shape {
    var rows: Int
    var columns: Int
    
    public var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(Double(rows), Double(columns))
        }
        
        set {
            self.rows = Int(newValue.first)
            self.columns = Int(newValue.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        //figure out how big each row/column needs to be
        let rowSize = rect.height / CGFloat(rows)
        let columnSize = rect.width / CGFloat(columns)
        
        //loop over all rows and columns, making alternating squares colored
        for row in 0 ..< rows {
            for column in 0 ..< columns {
                if (row + column).isMultiple(of: 2) {
                    //this square should be colored, add a rectangle here
                    let startX = columnSize * CGFloat(column)
                    let startY = rowSize * CGFloat(row)
                    
                    let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)
                    path.addRect(rect)
                }
            }
        }
        
        return path
    }
}


//challenge 1
struct Triangle: Shape {

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        return path
        
    }
}

struct Rectangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let constant: CGFloat = 20

        path.move(to: CGPoint(x: rect.midX - constant, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX + constant, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX + constant, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX - constant, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX - constant, y: rect.minY))
        
        return path
    }
}

struct Arrow: View {
    @State private var thickness: CGFloat = 5
    var body: some View {
        VStack {
            Triangle()
                .frame(width: 200, height: 200)
                
            
            Rectangle()
                .stroke(lineWidth: thickness)
                .frame(width: 100, height: 300)
                //challange 2
                .onTapGesture {
                    withAnimation {
                        self.thickness = CGFloat.random(in: 1...10)
                    }
                }
        }
    }
}

//challenge 3

struct ColorCyclingRectangle: View {
    var steps = 100
    var amount = 0.0
    var body: some View {
        ZStack {
            ForEach(0 ..< steps) { step in
                someRectangle()
                    .inset(by: CGFloat(step))
                    .strokeBorder(color(for: step, brightness: 1), lineWidth: 1)
            }
        }
        .frame(width: 300, height: 300)
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps) + self.amount
        
        if targetHue > 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

//InsettableShape and not just Shape to I can add "strokeBorder"
struct someRectangle: InsettableShape {
    var insetAmount: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX + insetAmount, y: rect.minY + insetAmount))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY + insetAmount))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.maxY - insetAmount))
        path.addLine(to: CGPoint(x: rect.minX + insetAmount, y: rect.maxY - insetAmount))
        path.addLine(to: CGPoint(x: rect.minX + insetAmount, y: rect.minY + insetAmount))
        
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var rect = self
        rect.insetAmount += amount
        return rect
    }
}
