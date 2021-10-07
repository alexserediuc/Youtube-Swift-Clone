//
//  ViewController.swift
//  Youtube Clone
//
//  Created by Alex on 07/10/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tabBarView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tabBarView.layer.borderWidth = 1
        tabBarView.layer.borderColor = UIColor.lightGray.cgColor
    }


}

