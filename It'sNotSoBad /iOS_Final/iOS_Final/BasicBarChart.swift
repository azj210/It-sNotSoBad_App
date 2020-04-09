//
//  BasicBarChart.swift
//  iOS_Final
//
//  Created by Alex Jiang on 12/10/19.
//  Copyright © 2019 Alex Jiang. All rights reserved.
//

import UIKit

class BasicBarChart: UIView {
    //chart layers
    private let mainLayer: CALayer = CALayer()
    
    //main layer to support scrolling
    private let scrollView: UIScrollView = UIScrollView()
    
    //whether or not to animate chart
    private var animated = false
    
    //compute position and frames of elements on bar chart
    private let presenter = BasicBarChartPresenter(barWidth: 43, space: 50)
    
    //Array of bar entries. Each entry contains info on line segments, curved line segments(for later implementation), positions, and frames of all elements on the bar
    private var barEntries: [BasicBarEntry] = [] {
        didSet {
            mainLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
            
            scrollView.contentSize = CGSize(width: presenter.computeContentWidth(), height: self.frame.size.height)
            mainLayer.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
            
            showHorizontalLines()
            
            for (index, entry) in barEntries.enumerated() {
                showEntry(index: index, entry: entry, animated: animated, oldEntry: oldValue.safeValue(at: index))
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
    
    private func setupView() {
        scrollView.layer.addSublayer(mainLayer)
        self.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateDataEntries(dataEntries: presenter.dataEntries, animated: false)
    }
    
    private func showEntry(index: Int, entry: BasicBarEntry, animated: Bool, oldEntry: BasicBarEntry?) {
        
        let cgColor = entry.data.color.cgColor
        
        //Show main bar
        mainLayer.addRectangleLayer(frame: entry.barFrame, color: cgColor, animated: animated, oldFrame: oldEntry?.barFrame)

        // Show an Int value above the bar
        mainLayer.addTextLayer(frame: entry.textValueFrame, color: cgColor, fontSize: 14, text: entry.data.textValue, animated: animated, oldFrame: oldEntry?.textValueFrame)

        // Show a title below the bar
        mainLayer.addTextLayer(frame: entry.bottomTitleFrame, color: cgColor, fontSize: 14, text: entry.data.title, animated: animated, oldFrame: oldEntry?.bottomTitleFrame)
    }
    
    private func showHorizontalLines() {
        self.layer.sublayers?.forEach({
            if $0 is CAShapeLayer {
                $0.removeFromSuperlayer()
            }
        })
        let lines = presenter.computeHorizontalLines(viewHeight: self.frame.height)
        lines.forEach { (line) in
            mainLayer.addLineLayer(lineSegment: line.segment, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor, width: line.width, isDashed: line.isDashed, animated: false, oldSegment: nil)
        }
    }
}

