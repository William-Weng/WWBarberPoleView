//
//  Constant.swift
//  WWBarberPoleView
//
//  Created by William.Weng on 2024/12/10.
//

import UIKit

// MARK: - Constant
extension WWBarberPoleView {
    
    // MARK: - 動畫的方向
    public enum Direction {
        case up
        case down
        case left
        case right
    }
    
    // MARK: - 混色的樣式
    public enum ColorType {
        case general
        case gradient(_ startPoint: CGPoint, _ endPoint: CGPoint)
    }
}
