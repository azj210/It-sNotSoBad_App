//
//  CurvedBarChart.swift
//  iOS_Final
//
//  Created by Alex Jiang on 12/12/19.
//  Copyright © 2019 Alex Jiang. All rights reserved.
//

import Foundation
import UIKit

class CurvedBarChart: UIView {
    private let mainLayer: CALayer = CALayer()
    private let scrollView: UIScrollView = UIScrollView()
    
    private let presenter = CurvedBarChartPresenter(barWidth: 140, space: -70)
    
    private var animated: Bool = false
    
    private var barEntries: [CurvedBarEntry] = [] {
        didSet {
            mainLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
            
            scrollView.contentSize = CGSize(width: presenter.computeContentWidth(), height: self.frame.size.height)
            mainLayer.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
            
            for (index, entry) in barEntries.enumerated() {
                showEntry(index: index, barEntry: entry, animated: animated, oldEntry: oldValue.safeValue(at: index))
            }
        }
    }
    
    func updateDataEntries(dataEntries: [DataEntry], animated: Bool) {
        self.animated = animated
        self.presenter.dataEntries = dataEntries
        self.barEntries = self.presenter.computeBarEntries(viewHeight: self.frame.height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateDataEntries(dataEntries: presenter.dataEntries, animated: false)
    }
    
    private func setupView() {
        scrollView.layer.addSublayer(mainLayer)
        self.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func showEntry(index: Int, barEntry: CurvedBarEntry, animated: Bool, oldEntry: CurvedBarEntry?) {
        let cgColor = barEntry.data.color.cgColor
        
        // Create the curved bar for an entry
        for (index, entry) in barEntry.mainBarEntry.curvedSegments.enumerated() {
            let oldSegment = oldEntry?.mainBarEntry.curvedSegments[index]
            mainLayer.addCurvedLayer(curvedSegment: entry, color: cgColor, animated: animated, oldSegment: oldSegment)
        }
        
        //Top bubble
        for (index, entry) in barEntry.topBubbleEntry.curvedSegments.enumerated() {
            let oldSegment = oldEntry?.topBubbleEntry.curvedSegments[index]
            mainLayer.addCurvedLayer(curvedSegment: entry, color: cgColor, animated: animated, oldSegment: oldSegment)
        }
        
        //Text in top bubble
        mainLayer.addTextLayer(frame: barEntry.topBubbleEntry.textValueFrame, color: UIColor.white.cgColor, fontSize: 14, text: barEntry.data.textValue, animated: animated, oldFrame: oldEntry?.topBubbleEntry.textValueFrame)
        
        //Line connecting to top bubble
        mainLayer.addLineLayer(lineSegment: barEntry.linkingLine, color: cgColor, width: 2.0, isDashed: false, animated: animated, oldSegment: oldEntry?.linkingLine)
        
        /// Category text
        mainLayer.addTextLayer(frame: barEntry.bottomTitleFrame, color: cgColor, fontSize: 14, text: barEntry.data.title, animated: animated, oldFrame: oldEntry?.bottomTitleFrame)
    }
}

