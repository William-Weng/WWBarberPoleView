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
    
    @IBOutlet weak var barberPoleView: WWBarberPoleView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        barberPoleView.layer.borderWidth = 5
        barberPoleView.layer.borderColor = UIColor.black.cgColor
        barberPoleView.start()
    }
}
