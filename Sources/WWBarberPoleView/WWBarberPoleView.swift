//
//  WWBarberPoleView.swift
//  WWBarberPoleView
//
//  Created by William.Weng on 2024/12/10.
//

import UIKit

// MARK: - 三色柱效果
open class WWBarberPoleView: UIView {

    private let earlyBeginTime = 1000.0         // 提前開始的時間 (避免一開始沒有旋轉條)
    private let heightRatio = 2.0               // 高度的放大比例 (因為旋轉條角度旋轉後，會造成高度變低)
    private let defaultColor: UIColor = .red    // 旋轉條的預設顏色
    
    private var rotationAngle = 45.0            // 旋轉條的旋轉角度
}

// MARK: - 公開函式
public extension WWBarberPoleView {
    
    /// [開始執行](https://zh.wikipedia.org/zh-tw/三色柱)
    /// - Parameters:
    ///   - direction: 動畫的方向
    ///   - rule: 進位規則
    ///   - colorType: 混色的樣式
    ///   - rotationAngle: 旋轉角度
    ///   - duration: [時間間隔](https://landpattern2630.wixsite.com/landpattern/copy-of-design-3)
    ///   - width: 寬度
    ///   - spacing: 間隔
    ///   - colors: 顏色
    func start(direction: Direction = .right, rule: FloatingPointRoundingRule = .up, colorType: ColorType = .general, rotationAngle: CGFloat = 45.0, duration: CFTimeInterval = 5.0, width: Double = 20.0, spacing: Double = 0.0, colors: [UIColor] = []) {
        
        let count = count(direction: direction, frame: bounds, width: width, spacing: spacing, rule: rule)
        
        clipsToBounds = true
        self.rotationAngle = rotationAngle
        
        for index in 0..<count {
            
            let poleLayer: CAGradientLayer
            
            switch colorType {
            case .general: poleLayer = generalLayerMaker(with: index, direction: direction, width: width, colors: colors)
            case .gradient(let startPoint, let endPoint): poleLayer = gradientLayerMaker(with: index, direction: direction, width: width, colors: colors, startPoint: startPoint, endPoint: endPoint)
            }
            
            let animation = animationMaker(with: index, direction: direction, duration: duration, count: count, position: poleLayer.position, width: width, spacing: spacing)
            
            poleLayer.add(animation, forKey: "flowAnimation")
            layer.addSublayer(poleLayer)
        }
    }
}

// MARK: - 小工具
private extension WWBarberPoleView {
    
    /// 根據相關參數找出最適合的數量
    /// - Parameters:
    ///   - direction: 動畫的方向
    ///   - frame: CGRect
    ///   - width: 旋轉條的寬度
    ///   - spacing: 旋轉條的間隔
    ///   - rule: 進位規則
    /// - Returns: Int
    func count(direction: Direction, frame: CGRect, width: CGFloat, spacing: CGFloat, rule: FloatingPointRoundingRule) -> Int {
        
        let _count: CGFloat
        
        switch direction {
        case .up, .down: _count = frame.height / (width + spacing)
        case .left, .right: _count = frame.width / (width + spacing)
        }
        
        return Int(_count.rounded(rule))
    }
    
    /// 橫移動畫產生器
    /// - Parameters:
    ///   - index: Int
    ///   - direction: 動畫的方向
    ///   - duration: 間隔的時間
    ///   - count: 旋轉條的數量
    ///   - position: 旋轉條的位置
    ///   - width: 旋轉條的寬度
    ///   - spacing: 旋轉條的間隔
    /// - Returns: CABasicAnimation
    func animationMaker(with index: Int, direction: Direction, duration: CGFloat, count: Int, position: CGPoint, width: CGFloat, spacing: CGFloat) -> CABasicAnimation {
        
        let keyPath: String
        let fromValue: CGFloat
        let toValue: CGFloat
        let timingFunction = CAMediaTimingFunction(name: .linear)
        let beginTime = CACurrentMediaTime() + (duration / Double(count)) * Double(index) - earlyBeginTime
        
        switch direction {
        case .up:
            keyPath = "position.y"
            fromValue = position.y
            toValue = fromValue + frame.height + (width + spacing + frame.height) * heightRatio
        case .down:
            keyPath = "position.y"
            toValue = position.y
            fromValue = toValue + frame.height + (width + spacing + frame.height) * heightRatio
        case .left:
            keyPath = "position.x"
            fromValue = position.x
            toValue = fromValue + frame.width + (width + spacing + frame.width) * heightRatio
        case .right:
            keyPath = "position.x"
            toValue = position.x
            fromValue = toValue + frame.width + (width + spacing + frame.width) * heightRatio
        }
        
        let animation = CAAnimation._basicAnimation(keyPath: keyPath, delegate: nil, fromValue: toValue, toValue: fromValue, duration: duration, repeatCount: .infinity, fillMode: .forwards, timingFunction: timingFunction, beginTime: beginTime, isRemovedOnCompletion: true)
        
        return animation
    }
    
    /// [旋轉條紋產生器](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/讓-calayer-繞著自己的中心點旋轉-9d2497ef401d)
    /// - Parameters:
    ///   - index: Int
    ///   - direction: 動畫的方向
    ///   - width: 寬度
    ///   - colors: 顏色
    /// - Returns: CAGradientLayer
    func generalLayerMaker(with index: Int, direction: Direction, width: CGFloat, colors: [UIColor]) -> CAGradientLayer {
        
        let layer = CAGradientLayer()
        let size: CGSize
        let position: CGPoint
        let radian: CGFloat
        var color = defaultColor
        
        switch direction {
        case .up, .down: 
            radian = -rotationAngle._radian()
            size = .init(width: frame.width * heightRatio, height: width)
            position = CGPoint(x: bounds.midX, y: -frame.height)
        case .left, .right:
            radian = rotationAngle._radian()
            size = .init(width: width, height: frame.height * heightRatio)
            position = CGPoint(x: -frame.width, y: bounds.midY)
        }
        
        if (!colors.isEmpty) { color = colors[safe: index % colors.count] ?? defaultColor }
        
        layer.frame = CGRect(origin: .zero, size: size)
        layer.backgroundColor = color.cgColor
        layer.setAffineTransform(CGAffineTransform(rotationAngle: radian))
        layer.position = position

        return layer
    }
    
    /// 漸層旋轉條紋產生器
    /// - Parameters:
    ///   - index: Int
    ///   - direction: 動畫的方向
    ///   - width: 寬度
    ///   - colors: 顏色
    ///   - startPoint: 漸層方向起始點
    ///   - endPoint: 漸層方向結束點
    /// - Returns: CALayer
    func gradientLayerMaker(with index: Int, direction: Direction, width: CGFloat, colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) -> CAGradientLayer {
        
        let layer = generalLayerMaker(with: index, direction: direction, width: width, colors: colors)
        let newColors: [UIColor]
        
        switch direction {
        case .up, .down: newColors = colors.reversed()
        case .left, .right: newColors = colors
        }
        
        layer.colors = newColors.map { $0.cgColor }
        layer.startPoint = startPoint
        layer.endPoint = endPoint

        return layer
    }
}
