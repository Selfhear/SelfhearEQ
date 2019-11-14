//
//  ViewController2.swift
//  SelfhearEQ
//
//  Created by Maitree Hirunteeyakun on 18/10/19.
//  Copyright © 2019 Maitree Hirunteeyakul. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore

class ViewController2: UIViewController {
    var db: Firestore!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("innewsene")
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        // Do any additional setup after loading the view.
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
    
    @IBOutlet weak var genderval: UISegmentedControl!
    
    @IBOutlet weak var BDayPickr: UIDatePicker!
    
    @IBAction func Donebut(_ sender: Any) {
        let GenderQ = genderval.titleForSegment(at: genderval.selectedSegmentIndex)
        let Gender = (GenderQ ?? "")
        print(Gender)
        let myBDTimeStamp = self.BDayPickr?.date.timeIntervalSince1970
        let BirthDay = (myBDTimeStamp ?? -1)
        print(BirthDay)
        
        
        var ref: DocumentReference? = nil
        var colname="TestDataGain"
        if (TestMode==false){
            colname="DataGain"
        }

        ref = self.db.collection(colname).addDocument(data: [
            "g1": gaina[0],
            "g2": gaina[1],
            "g3": gaina[2],
            "g4": gaina[3],
            "g5": gaina[4],
            "timestamp": NSDate().timeIntervalSince1970,
            "Testmode": TestMode,
            "sender":UIDevice.current.name,
            "UserGender": Gender,
            "Birthday": BirthDay
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }

        let main = UIStoryboard(name:"Main",bundle: nil)
        let second=main.instantiateViewController(withIdentifier: "Stato")
        self.present(second,animated: true,completion: nil)
        
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
