//
//  DonateVC.swift
//  AppGain
//
//  Created by Mohamed Hegazy on 6/2/20.
//  Copyright © 2020 GoClean. All rights reserved.
//

import UIKit
import CBPinEntryView
class DonateVC: UIViewController, CBPinEntryViewDelegate {
    func entryChanged(_ completed: Bool) {
        print("writing")
    }
    
    func entryCompleted(with entry: String?) {
        print(entry!)
        if entry! != "5115" {
            
            otpTF.setError(isError: true)
        }else {
            otpTF.setError(isError: false)
            self.dismiss(animated: true, completion: nil)

        }
    }
    

    @IBAction func resetButton(_ sender: Any) {
        otpTF.clearEntry()
    }
    @IBOutlet weak var otpTF: CBPinEntryView! {
        didSet {
            otpTF.delegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        otpTF.keyboardType = 4
        // Do any additional setup after loading the view.
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
