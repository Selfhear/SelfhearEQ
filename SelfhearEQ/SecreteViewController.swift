//
//  SecreteViewController.swift
//  SelfhearEQ
//
//  Created by Maitree Hirunteeyakun on 20/10/19.
//  Copyright © 2019 Maitree Hirunteeyakul. All rights reserved.
//

import UIKit

class SecreteViewController: UIViewController {

    @IBOutlet weak var Testmodebutt: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if TestMode{
            Testmodebutt.setOn(true, animated: false)
        }
        else
        {
            Testmodebutt.setOn(false, animated: false)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
      }
    
    @IBAction func testmodeswap(_ sender: Any) {
        if TestMode{
            TestMode=false
        }
        else
        {
            TestMode=true
        }
        print("Now Test Mode = ",TestMode)
    }
    override open var shouldAutorotate: Bool {
          return false
      }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
          return .landscapeLeft
      }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
          return .landscapeLeft
      }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
