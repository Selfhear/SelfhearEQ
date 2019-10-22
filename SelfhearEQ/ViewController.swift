//
//  ViewController.swift
//  SelfhearEQ
//
//  Created by Maitree Hirunteeyakun on 9/10/19.
//  Copyright © 2019 Maitree Hirunteeyakul. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseCore
import FirebaseFirestore
//import AudioKit

var gaina = [Float(1),Float(1),Float(1),Float(1),Float(1)]
var para=false

var headphonesConnected = false
    
extension AVAudioSession {

    static var isHeadphonesConnected: Bool {
        return sharedInstance().isHeadphonesConnected
    }

    var isHeadphonesConnected: Bool {
        return !currentRoute.outputs.filter { $0.isHeadphones }.isEmpty
    }

}

extension AVAudioSessionPortDescription {
    var isHeadphones: Bool {
        return portType == AVAudioSession.Port.headphones
    }
}

class ViewController: UIViewController {
    var db: Firestore!
    
    
    @IBOutlet weak var Buttonn: UIButton!
    @IBOutlet weak var Slider1: UISlider!
    @IBOutlet weak var Slider2: UISlider!
    @IBOutlet weak var Slider3: UISlider!
    @IBOutlet weak var Slider4: UISlider!
    @IBOutlet weak var Slider5: UISlider!
    var engine:AVAudioEngine!
    var EQNode:AVAudioUnitEQ!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // [START setup]
        gaina = [Float(1),Float(1),Float(1),Float(1),Float(1)]
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        //addAdaLovelace()
        Slider1.transform=CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        Slider2.transform=CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        Slider3.transform=CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        Slider4.transform=CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        Slider5.transform=CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        print("isHeadphones connected: \(AVAudioSession.isHeadphonesConnected)")
        engine = AVAudioEngine()
        //engine.reset()
        //engine.inputNode.removeTap(onBus: 0)
        EQNode = AVAudioUnitEQ(numberOfBands: 5)
        EQNode.globalGain = 1
        engine.attach(EQNode)
        print("attachNode")
        SetupEQ()
        print("After SetupEQ")
        tieupEQnode()
        print("After tieupEQnode")
        startEngine()
        print("After startEngine")
        let lpgr=UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation(press:)))
        lpgr.minimumPressDuration=3.0
        Buttonn.addGestureRecognizer(lpgr)
    }
    @objc func addAnnotation(press:UILongPressGestureRecognizer){
        if press.state == .began{
            if engine.isRunning{
                //engine.inputNode.removeTap(onBus: 0)
                engine.stop()
            print("engin stoped")
            }
            let main = UIStoryboard(name:"Main",bundle: nil)
            let sec=main.instantiateViewController(withIdentifier: "SeVC")
            self.present(sec,animated: true,completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
       }
    
    
    
    @objc func handleRouteChange(_ notification: Notification) {
        guard
        let userInfo = notification.userInfo,
        let reasonRaw = userInfo[AVAudioSessionRouteChangeReasonKey] as? NSNumber,
            let reason = AVAudioSession.RouteChangeReason(rawValue: reasonRaw.uintValue)
        else { fatalError("Strange... could not get routeChange") }
        switch reason {
        case .oldDeviceUnavailable:
            print("oldDeviceUnavailable")
        case .newDeviceAvailable:
            print("newDeviceAvailable")
            if AVAudioSession.isHeadphonesConnected {
                 print("Just connected headphones")
            }
        case .routeConfigurationChange:
            print("routeConfigurationChange")
        case .categoryChange:
            print("categoryChange")
        default:
            print("not handling reason")
        }
    }
    
    private func addAdaLovelace() {
        // [START add_ada_lovelace]
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "first": "Ada",
            "last": "Lovelace",
            "born": 1815
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        // [END add_ada_lovelace]
    }
    
    func listenForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleRouteChange(_:)), name:AVAudioSession.routeChangeNotification, object: nil)
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
      
  
    func tieupEQnode(){
        print("in tieupEQnode")
        //let recordingFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)
        engine.reset()
        print("DEBUGinTie : Before recordingFormat")
        let recordingFormat = engine.inputNode.outputFormat(forBus: 0)
        print("DEBUGinTie : After recordingFormat")
        
//        engine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
//            print( "YES! Got some samples!")
//        }
        print("DEBUGinTie : After installTap")
        configureAudioSession()
        //engine.inputNode.removeTap(onBus: 0)
        //let recordingFormat = engine.inputNode.inputFormat(forBus: 0)
        print("channelcount:",engine.inputNode.inputFormat(forBus: 0).channelCount)
        var format = engine.inputNode.inputFormat(forBus: 0)
        print("set format")
        engine.connect(engine.inputNode, to: EQNode, format: format)
        print("connected engine.inputNode to EQNode")
        engine.connect(EQNode, to: engine.mainMixerNode, format: format)
        print("connected EQNode to engine.mainMixerNode")
        //engine.connect(engine.inputNode, to: engine.mainMixerNode, format: recordingFormat)
        print("tested connect")
    }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: AVAudioSession.CategoryOptions.mixWithOthers)
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print("ERROR: CANNOT PLAY MUSIC IN BACKGROUND.")
        }
    }
    
    func SetupEQ () {
        print(gaina)
        print("in SetupEQ")
        
        var filterParams1 = EQNode.bands[0] as AVAudioUnitEQFilterParameters
        filterParams1.filterType = .parametric
        // 20hz to nyquist
        filterParams1.frequency = 100
        //The value range of values is 0.05 to 5.0 octaves
        filterParams1.bandwidth = 2.0
        filterParams1.bypass = para
        // in db -96 db through 24 d
        filterParams1.gain = gaina[0]
        
        
        var filterParams2 = EQNode.bands[1] as AVAudioUnitEQFilterParameters
        filterParams2.filterType = .parametric
        filterParams2.frequency = 400
        filterParams2.bandwidth = 2.0
        filterParams2.bypass = para
        filterParams2.gain = gaina[1]
        
        var filterParams3 = EQNode.bands[2] as AVAudioUnitEQFilterParameters
        filterParams3.filterType = .parametric
        filterParams3.frequency = 1600
        filterParams3.bandwidth = 2.0
        filterParams3.bypass = para
        filterParams3.gain = gaina[2]
        
        var filterParams4 = EQNode.bands[3] as AVAudioUnitEQFilterParameters
        filterParams4.filterType = .parametric
        filterParams4.frequency = 6400
        filterParams4.bandwidth = 2.0
        filterParams4.bypass = para
        filterParams4.gain =  gaina[3]
        
        var filterParams5 = EQNode.bands[4] as AVAudioUnitEQFilterParameters
        filterParams5.filterType = .parametric
        filterParams5.frequency = 25600
        filterParams5.bandwidth = 2.0
        filterParams5.bypass = para
        filterParams5.gain =  gaina[4]
        
    }
    
    func startEngine() {
            var error: NSError?
            print("in startEngine")
            engine.prepare()
            print("done prepare")
            do {
                try engine.start()
            } catch {
                print(error)
            }
            print("done start")
        }
    
    
    @IBAction func Done(_ sender: UIButton) {
        print("in Done fun button",engine.isRunning)
        if engine.isRunning{
            //engine.inputNode.removeTap(onBus: 0)
        engine.stop()
        print("engin stoped")
        }
        let alert = UIAlertController(title: "Alert", message: "Are you sure to summit this result?\nThis prosess could NOT be revised.", preferredStyle: UIAlertController.Style.alert)
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: {action in
            print("incon")
            var ref: DocumentReference? = nil
            ref = self.db.collection("DataGain").addDocument(data: [
                "g1": gaina[0],
                "g2": gaina[1],
                "g3": gaina[2],
                "g4": gaina[3],
                "g5": gaina[4]
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
            
            let main = UIStoryboard(name:"Main",bundle: nil)
            let second=main.instantiateViewController(withIdentifier: "SVC")
            self.present(second,animated: true,completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {action in
            print("in cancle")
            self.startEngine()
            
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        print("donee")
//        let secondViewController:ViewController2 = ViewController2()
//
//        self.present(secondViewController, animated: true, completion: nil)
    }
    
    @IBAction func gain1(sender: UISlider) {
//            var val = sender.value
//            print(String(format: "gain1 %f", val))
//
//            var filterParams = EQNode.bands[0] as AVAudioUnitEQFilterParameters
//            filterParams.gain = val
//            //EQNode.globalGain = val
//        engine.stop()
//        var format = engine.inputNode.inputFormat(forBus: 0)
//        engine.connect(engine.inputNode, to: EQNode, format: format)
//        engine.connect(EQNode, to: engine.mainMixerNode, format: format)
//        startEngine()
        var format = engine.inputNode.inputFormat(forBus: 0)
        gaina[0] = sender.value
//        engine.stop()
        SetupEQ()
//        engine.attach(EQNode)
//        engine.connect(engine.inputNode, to: EQNode, format: format)
//        engine.connect(EQNode, to: engine.mainMixerNode, format: format)
//        startEngine()
        
        }
    
    @IBAction func gain2(sender: UISlider) {
            var format = engine.inputNode.inputFormat(forBus: 0)
            gaina[1] = sender.value
//            engine.stop()
            SetupEQ()
//            engine.attach(EQNode)
//            engine.connect(engine.inputNode, to: EQNode, format: format)
//            engine.connect(EQNode, to: engine.mainMixerNode, format: format)
//            startEngine()
        }
    
    @IBAction func gain3(sender: UISlider) {
            var format = engine.inputNode.inputFormat(forBus: 0)
            gaina[2] = sender.value
//            engine.stop()
            SetupEQ()
//            engine.attach(EQNode)
//            engine.connect(engine.inputNode, to: EQNode, format: format)
//            engine.connect(EQNode, to: engine.mainMixerNode, format: format)
//            startEngine()
        }
    
    @IBAction func gain4(sender: UISlider) {
           var format = engine.inputNode.inputFormat(forBus: 0)
            gaina[3] = sender.value
//            engine.stop()
            SetupEQ()
//            engine.attach(EQNode)
//            engine.connect(engine.inputNode, to: EQNode, format: format)
//            engine.connect(EQNode, to: engine.mainMixerNode, format: format)
//            startEngine()
        }
    
    @IBAction func gain5(sender: UISlider) {
             var format = engine.inputNode.inputFormat(forBus: 0)
               gaina[4] = sender.value
//               engine.stop()
               SetupEQ()
//                engine.attach(EQNode)
//               engine.connect(engine.inputNode, to: EQNode, format: format)
//               engine.connect(EQNode, to: engine.mainMixerNode, format: format)
//               startEngine()
           }
}



