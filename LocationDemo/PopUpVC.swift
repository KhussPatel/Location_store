//
//  PopUpVC.swift
//  LocationDemo
//
//  Created by My Mac on 03/01/20.
//  Copyright © 2020 My Mac. All rights reserved.
//

import UIKit

class PopUpVC: UIViewController {

    @IBOutlet var vw_pop: UIView!
    @IBOutlet weak var vw_main: UIView!
    
    
    @IBOutlet weak var img_temp: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Loding....")
        
    }
    
    
    @IBAction func btn_POP(_ sender: Any) {
        
        vw_pop.frame.origin = vw_main.bounds.origin;

        vw_pop.center = vw_main.convert(vw_main.center, from: vw_pop);
        
        vw_main.addSubview(vw_pop)
        
        
    }
    
    @IBAction func btn_DELETE(_ sender: Any) {
        print("DELETE")
        
        vw_pop.removeFromSuperview()
        
    }
    
}
