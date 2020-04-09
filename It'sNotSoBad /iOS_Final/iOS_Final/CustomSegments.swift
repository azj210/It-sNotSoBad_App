//
//  CustomSegments.swift
//  iOS_Final
//
//  Created by Alex Jiang on 12/10/19.
//  Copyright © 2019 Alex Jiang. All rights reserved.
//

import Foundation
import CoreGraphics.CGGeometry

struct CurvedSegment {
    let startPoint: CGPoint
    let endPoint: CGPoint
    let toPoint: CGPoint
    let controlPoint1: CGPoint
    let controlPoint2: CGPoint
}

struct LineSegment {
    let startPoint: CGPoint
    let endPoint: CGPoint
}
