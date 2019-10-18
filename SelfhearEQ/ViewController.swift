//
//  ViewController.swift
//  SelfhearEQ
//
//  Created by Maitree Hirunteeyakun on 9/10/19.
//  Copyright © 2019 Maitree Hirunteeyakul. All rights reserved.
//

import UIKit
import AVFoundation
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

    @IBOutlet weak var Slider1: UISlider!
    @IBOutlet weak var Slider2: UISlider!
    @IBOutlet weak var Slider3: UISlider!
    @IBOutlet weak var Slider4: UISlider!
    @IBOutlet weak var Slider5: UISlider!
    var engine:AVAudioEngine!
    var EQNode:AVAudioUnitEQ!
    override func viewDidLoad() {
        super.viewDidLoad()
        Slider1.transform=CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        Slider2.transform=CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        Slider3.transform=CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        Slider4.transform=CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        Slider5.transform=CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        print("isHeadphones connected: \(AVAudioSession.isHeadphonesConnected)")
        engine = AVAudioEngine()
        EQNode = AVAudioUnitEQ(numberOfBands: 5)
        EQNode.globalGain = 1
        engine.attach(EQNode)
        SetupEQ()
        tieupEQnode()
        startEngine()
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
        var format = engine.inputNode.inputFormat(forBus: 0)
        engine.connect(engine.inputNode, to: EQNode, format: format)
        engine.connect(EQNode, to: engine.mainMixerNode, format: format)
    }
    
    func SetupEQ () {
        print(gaina)
        print("in initAudioEngine")
        
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
                _ = try engine.start()
            } catch {
                print("error")
            }
            print("done start")
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



