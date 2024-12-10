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
    private let earlyStartPositionX = 100.0     // 旋轉條提前開始的位置 (因為旋轉條角度旋轉後，會造成高度變低，看起來不會是從頭開始的)
    private let rotationAngle = 45.0            // 旋轉條的旋轉角度
}

// MARK: - 公開函式
public extension WWBarberPoleView {
    
    /// [開始執行](https://zh.wikipedia.org/zh-tw/三色柱)
    /// - Parameters:
    ///   - duration: [時間間隔](https://landpattern2630.wixsite.com/landpattern/copy-of-design-3)
    ///   - width: 寬度
    ///   - spacing: 間隔
    ///   - colors: 顏色
    public func start(duration: CFTimeInterval = 5.0, width: Double = 20.0, spacing: Double = 20.0, colors: [UIColor] = [.red ,.yellow, .green]) {
        
        let count = count(with: bounds, width: width, spacing: spacing)
        clipsToBounds = true
        
        for index in 0..<count {
            
            let poleLayer = layerMaker(with: index, width: width, colors: colors)
            let animation = animationMaker(with: index, duration: duration, count: count, position: poleLayer.position, width: width, spacing: spacing)
            
            poleLayer.add(animation, forKey: "flowAnimation")
            layer.addSublayer(poleLayer)
        }
    }
}

// MARK: - 小工具
private extension WWBarberPoleView {
    
    /// 根據相關參數找出最適合的數量
    /// - Parameters:
    ///   - frame: CGRect
    ///   - width: 旋轉條的寬度
    ///   - spacing: 旋轉條的間隔
    /// - Returns: Int
    func count(with frame: CGRect, width: CGFloat, spacing: CGFloat) -> Int {
        let count = frame.width / (width + spacing)
        return Int(count.rounded(.up))
    }
    
    /// 橫移動畫產生器
    /// - Parameters:
    ///   - index: Int
    ///   - duration: 間隔的時間
    ///   - count: 旋轉條的數量
    ///   - position: 旋轉條的位置
    ///   - width: 旋轉條的寬度
    ///   - spacing: 旋轉條的間隔
    /// - Returns: CABasicAnimation
    func animationMaker(with index: Int, duration: CGFloat, count: Int, position: CGPoint, width: CGFloat, spacing: CGFloat) -> CABasicAnimation {
        
        let keyPath = "position.x"
        let fromValue = position.x
        let toValue = fromValue + frame.width + (width + spacing + earlyStartPositionX) * heightRatio
        let timingFunction = CAMediaTimingFunction(name: .linear)
        let beginTime = CACurrentMediaTime() + (duration / Double(count)) * Double(index) - earlyBeginTime
        
        let animation = CAAnimation._basicAnimation(keyPath: keyPath, delegate: nil, fromValue: fromValue, toValue: toValue, duration: duration, repeatCount: .infinity, fillMode: .forwards, timingFunction: timingFunction, beginTime: beginTime, isRemovedOnCompletion: true)
        
        return animation
    }
    
    /// [旋轉條產生器](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/讓-calayer-繞著自己的中心點旋轉-9d2497ef401d)
    /// - Parameters:
    ///   - index: Int
    ///   - width: 寬度
    ///   - colors: 顏色
    /// - Returns: CALayer
    func layerMaker(with index: Int, width: CGFloat, colors: [UIColor]) -> CALayer {
        
        let layer = CALayer()
        
        layer.frame = CGRect(origin: .zero, size: .init(width: width, height: frame.height * heightRatio))
        layer.backgroundColor = colors[index % colors.count].cgColor
        layer.setAffineTransform(CGAffineTransform(rotationAngle: rotationAngle._radian()))
        layer.position = CGPoint(x: -earlyStartPositionX, y: bounds.midY)
        
        return layer
    }
}
