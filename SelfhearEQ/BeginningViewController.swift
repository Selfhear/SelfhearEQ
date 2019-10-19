//
//  BeginningViewController.swift
//  SelfhearEQ
//
//  Created by Maitree Hirunteeyakun on 20/10/19.
//  Copyright © 2019 Maitree Hirunteeyakul. All rights reserved.
//

import UIKit
import AVKit
class BeginningViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    let playerViewCon=AVPlayerViewController()
    @IBAction func Starto(_ sender: UIButton) {
        
        guard let path=Bundle.main.path(forResource: "IMG_4916", ofType: "mov") else {
            return
        }
        let vedioURL=URL(fileURLWithPath: path)
        let player=AVPlayer(url: vedioURL)
        
        playerViewCon.player=player
        playerViewCon.showsPlaybackControls = false
       NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerViewCon.player?.currentItem)
        self.present(playerViewCon,animated: true){
            self.playerViewCon.player?.play()
            print("afterplay")
//            let main = UIStoryboard(name:"Main",bundle: nil)
//            let second=main.instantiateViewController(withIdentifier: "MVC")
//            self.present(second,animated: true,completion: nil)
        }
        print("ingap")
//        let main = UIStoryboard(name:"Main",bundle: nil)
//        let second=main.instantiateViewController(withIdentifier: "MVC")
//        self.present(second,animated: true,completion: nil)
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        
        let main = UIStoryboard(name:"Main",bundle: nil)
        let second=main.instantiateViewController(withIdentifier: "MVC")
        playerViewCon.dismiss(animated: false, completion: nil)
        self.present(second,animated: true,completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
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
