//
//  CurvedBarChartPresenter.swift
//  iOS_Final
//
//  Created by Alex Jiang on 12/12/19.
//  Copyright © 2019 Alex Jiang. All rights reserved.
//

import Foundation
import CoreGraphics.CGGeometry

class CurvedBarChartPresenter {
    let barWidth: CGFloat
    let space: CGFloat
    
    
    private let bottomSpace: CGFloat = 40.0

    private let topSpace: CGFloat = 140
    
    var dataEntries: [DataEntry] = []
    
    init(barWidth: CGFloat = 200, space: CGFloat = -20) {
        self.barWidth = barWidth
        self.space = space
    }
    
    func computeContentWidth() -> CGFloat {
        return (barWidth) * CGFloat(dataEntries.count + 1)/2
    }
    
    func computeBarEntries(viewHeight: CGFloat) -> [CurvedBarEntry] {
        var result: [CurvedBarEntry] = []
        
        for (index, entry) in dataEntries.enumerated() {
            let entryHeight = CGFloat(entry.height) * (viewHeight - bottomSpace - topSpace)
            let xPosition: CGFloat = CGFloat(index) * (barWidth + space)
            let yPosition = viewHeight - bottomSpace - entryHeight
            
            let barEntry = CurvedBarEntry(origin: CGPoint(x: xPosition, y: yPosition), barWidth: barWidth, barHeight: entryHeight, data: entry)
            
            result.append(barEntry)
        }
        
        return result
    }
}




