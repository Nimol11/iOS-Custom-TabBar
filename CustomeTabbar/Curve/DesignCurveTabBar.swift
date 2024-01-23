//
//  DesignCurveTabBar.swift
//  CustomeTabbar
//
//  Created by Nimol on 23/1/24.
//

import UIKit

class DesignCurveTabBar: UITabBar {

    private var tabBarWidth: CGFloat = 0
    private var index: CGFloat = 0 {
        willSet {
            self.previousIndex = index
        }
    }
    private var animation: Bool = false
    private var selectedImage: UIImage?
    private var previousIndex: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    override func draw(_ rect: CGRect) {
        drawCurve()
        
    }
}

extension DesignCurveTabBar {
    func select(itemAt: Int, animation: Bool) {
        self.index = CGFloat(itemAt)
        self.animation = animation
        self.selectedImage = self.selectedItem?.selectedImage
        self.selectedItem?.selectedImage = nil
        self.setNeedsDisplay()
    }
    private func drawCurve() {
        let fillColor: UIColor = .white
        tabBarWidth = self.bounds.width / CGFloat(self.items?.count ?? 0)
        let bezierPath = drawPath(for: index)
        
        bezierPath.close()
        fillColor.setFill()
        let mask = CAShapeLayer()
        mask.fillRule = .evenOdd
        mask.fillColor = UIColor.white.cgColor
        mask.path = bezierPath.cgPath
        if (self.animation) {
            let bezAnimation = CABasicAnimation(keyPath: "path")
            let bezPathFrom = drawPath(for: previousIndex)
            bezAnimation.toValue = bezierPath.cgPath
            bezAnimation.fromValue = bezPathFrom.cgPath
            bezAnimation.duration = 0.3
            bezAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            mask.add(bezAnimation, forKey: nil)
        }
        self.layer.mask = mask
    
    }
    private func customInit() {
        self.tintColor = .white
        self.barTintColor = .white
        self.backgroundColor = .white
    }
    
    private func drawPath(for index: CGFloat) -> UIBezierPath {
        let bezierPath = UIBezierPath()
        let tabBarHeight: CGFloat = tabBarWidth
        let leftPoint = CGPoint(x: (index * tabBarWidth), y: 0)
        let leftPointCurveUp = CGPoint(x: (tabBarWidth * index) + tabBarWidth / 5,
                                       y: 0)
        
        let leftPointCurveDown = CGPoint(
            x: ((index * tabBarWidth) - tabBarWidth * 0.2) + tabBarWidth / 4,
            y: tabBarHeight * 0.40
        )
        let middlePoint = CGPoint(
            x: (tabBarWidth * index) + tabBarWidth / 2,
            y: tabBarHeight * 0.4
        )
        let middlePointCurveDown = CGPoint(
            x: (((index * tabBarWidth) - tabBarWidth * 0.2) + tabBarWidth / 10) + tabBarWidth,
            y: tabBarHeight * 0.4
        )
        let middlePointCurveUp = CGPoint(
            x: (((tabBarWidth * index) + tabBarWidth) - tabBarWidth / 5),
            y: 0
        )
        let rightPoint = CGPoint(x: (tabBarWidth * index) + tabBarWidth, y: 0)
        bezierPath.move(to: leftPoint)
        bezierPath.addCurve(to: middlePoint, controlPoint1: leftPointCurveUp, controlPoint2: leftPointCurveDown)
        bezierPath.addCurve(to: rightPoint, controlPoint1: middlePointCurveDown, controlPoint2: middlePointCurveUp)
        bezierPath.append(UIBezierPath(rect: self.bounds))
        return bezierPath
    }
}
