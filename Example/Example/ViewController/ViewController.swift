//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2024/12/10.
//

import UIKit
import WWBarberPoleView

// MARK: - ViewController
final class ViewController: UIViewController {
    
    @IBOutlet weak var barberPoleView1: WWBarberPoleView!
    @IBOutlet weak var barberPoleView2: WWBarberPoleView!

    override func viewDidLoad() {
        super.viewDidLoad()
        demo1()
        demo2()
    }
}

// MARK: - 小工具
private extension ViewController {
    
    func demo1() {
        barberPoleView1.layer.borderWidth = 5
        barberPoleView1.layer.borderColor = UIColor.black.cgColor
        barberPoleView1.start()
    }
    
    func demo2() {
        barberPoleView2.layer.borderWidth = 5
        barberPoleView2.layer.borderColor = UIColor.black.cgColor
        barberPoleView2.start(direction: .down, colors: [.red])
    }
}
