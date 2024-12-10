//
//  Extension.swift
//  WWBarberPoleView
//
//  Created by William.Weng on 2024/12/10.
//

import UIKit

// MARK: - Float (function)
extension Double {
    
    /// 180° => π
    func _radian() -> Double { return (self / 180.0) * .pi }
    
    /// π => 180°
    func _angle() -> Double { return self * (180.0 / .pi) }
}

// MARK: - Collection (override function)
extension Collection {

    /// [為Array加上安全取值特性 => nil](https://stackoverflow.com/questions/25329186/safe-bounds-checked-array-lookup-in-swift-through-optional-bindings)
    subscript(safe index: Index) -> Element? { return indices.contains(index) ? self[index] : nil }
}

// MARK: - CAAnimation (static function)
extension CAAnimation {
    
    /// [Layer動畫產生器 (CABasicAnimation)](https://jjeremy-xue.medium.com/swift-說說-cabasicanimation-9be31ee3eae0)
    /// - Parameters:
    ///   - keyPath: [要產生的動畫key值](https://blog.csdn.net/iosevanhuang/article/details/14488239)
    ///   - delegate: [CAAnimationDelegate?](https://juejin.cn/post/6936070813648945165)
    ///   - fromValue: 開始的值
    ///   - toValue: 結束的值
    ///   - duration: 動畫時間
    ///   - repeatCount: 播放次數
    ///   - fillMode: [CAMediaTimingFillMode](https://juejin.cn/post/6991371790245183496)
    ///   - timingFunction: CAMediaTimingFunction?
    ///   - beginTime: CFTimeInterval
    ///   - isRemovedOnCompletion: Bool
    /// - Returns: Constant.CAAnimationInformation
    static func _basicAnimation(keyPath: String, delegate: CAAnimationDelegate?, fromValue: Any?, toValue: Any?, duration: CFTimeInterval, repeatCount: Float, fillMode: CAMediaTimingFillMode, timingFunction: CAMediaTimingFunction?, beginTime: CFTimeInterval, isRemovedOnCompletion: Bool) -> CABasicAnimation {
        
        let animation = CABasicAnimation(keyPath: keyPath)
        
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.fillMode = fillMode
        animation.isRemovedOnCompletion = isRemovedOnCompletion
        animation.delegate = delegate
        animation.timingFunction = timingFunction
        animation.beginTime = beginTime
        
        return animation
    }
}
