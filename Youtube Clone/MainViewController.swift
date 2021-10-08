//
//  ViewController.swift
//  Youtube Clone
//
//  Created by Alex on 07/10/2021.
//

import UIKit


class MainViewController: UIViewController {

    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var videoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tabBarView.layer.borderWidth = 1
        tabBarView.layer.borderColor = UIColor.lightGray.cgColor
        
        videoTableView.delegate = self
        videoTableView.dataSource = self
    }   
}

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you taped me")
        
        let videoLauncher = VideoLauncher()
        videoLauncher.showVideoPlayer()
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath)
        
        return cell
    }
}

