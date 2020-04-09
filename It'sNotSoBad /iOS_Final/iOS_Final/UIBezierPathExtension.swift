//
//  UIBezierPathExtension.swift
//  iOS_Final
//
//  Created by Alex Jiang on 12/10/19.
//  Copyright © 2019 Alex Jiang. All rights reserved.
//

import UIKit

//Not utilized currently but can be used in the future for bezier curves
//and to make more visually appealing graphs
extension UIBezierPath {
    convenience init(curvedSegment: CurvedSegment) {
        self.init()
        self.move(to: curvedSegment.startPoint)
        self.addCurve(to: curvedSegment.toPoint, controlPoint1: curvedSegment.controlPoint1, controlPoint2: curvedSegment.controlPoint2)
        self.addLine(to: curvedSegment.endPoint)
    }
    
    convenience init(lineSegment: LineSegment) {
        self.init()
        self.move(to: lineSegment.startPoint)
        self.addLine(to: lineSegment.endPoint)
    }
}
