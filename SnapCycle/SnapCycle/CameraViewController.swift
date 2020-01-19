//
//  ViewController.swift
//  SnapCycle
//
//  Created by Sion Daniel on 1/18/20.
//  Copyright © 2020 Sion Daniel. All rights reserved.
//

import UIKit
import ARKit

class CameraViewController: UIViewController {

    
    @IBOutlet var previewView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        previewView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        previewView.session.run(configuration)
    }
    
    @IBAction func snap(_ sender: Any) {
        let currentFrame = previewView.snapshot()
        let vc = self.storyboard?.instantiateViewController(identifier: "Profile") as! ProfileViewController
        vc.image = currentFrame
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension CameraViewController: ARSCNViewDelegate {
    
}

