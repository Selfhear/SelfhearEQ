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

class ViewController: UIViewController {

    var engine:AVAudioEngine!
    var EQNode:AVAudioUnitEQ!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func tieupEQnode(){
        var format = engine.inputNode.inputFormat(forBus: 0)
        engine.connect(engine.inputNode, to: EQNode, format: format)
        engine.connect(EQNode, to: engine.mainMixerNode, format: format)
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



