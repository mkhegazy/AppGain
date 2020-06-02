//
//  ViewController.swift
//  AppGain
//
//  Created by Mohamed Hegazy on 6/1/20.
//  Copyright © 2020 GoClean. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import UICircularProgressRing
import FBSDKShareKit
import NotificationBannerSwift
class ViewController: UIViewController, SharingDelegate {

    @IBOutlet weak var collectedLabel: UILabel!
    @IBOutlet weak var TotalLabel: UILabel!
    @IBOutlet weak var ring: UICircularProgressRing!
    var collectedAmount = 0
    var targetAmount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = Timer.scheduledTimer(timeInterval: 30.0, target: self,selector: #selector(execute),userInfo: nil,repeats: true)
        var formatter = UICircularProgressRingFormatter(showFloatingPoint: true)
        formatter.valueIndicator = "AED"
        formatter.decimalPlaces = 0
        
        ring.valueFormatter = formatter

        // Do any additional setup after loading the view.
    }
    
    @IBAction func shareTextButton(_ sender: UIButton) {

        // text to share
        let text = "This is some text that I want to share."

        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)

    }
    
    @IBAction func fbShare(_ sender: UIButton) {
        let fbContent = ShareLinkContent()
        fbContent.quote = "Testing APp"
        fbContent.contentURL = URL.init(string: "https://developers.facebook.com")! 
        ShareDialog(fromViewController: self, content: fbContent, delegate: self).show()

    }
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        if sharer.shareContent.pageID != nil {
            print("Share: Success")
        }
    }
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        print("Share: Fail")
    }
    func sharerDidCancel(_ sharer: Sharing) {
        print("Share: Cancel")
    }

    @objc func execute() {
        fetchAPI()
    }
    func fetchAPI() {
        AF.request("http://ws.quantatel.com/ikhair/causes?country=AE").responseJSON { (response) in
            switch response.result {
            case .success:
                print("data success")
                let valueJSON = JSON(response.value as Any)["ikhair"]["country"][0]["-causes"]["cause"][0]
                print(valueJSON)
                //
                self.targetAmount = valueJSON["-targetAmount"].intValue
                
                self.collectedAmount = valueJSON["-collectedAmount"].intValue
                self.collectedLabel.text = "الهدف\(self.collectedAmount) درهم "
                self.TotalLabel.text = "المجمع\(self.targetAmount) درهم "

                self.ring.startProgress(to: CGFloat(self.collectedAmount), duration: 0.0) {
                
                  print("Done animating!")
                  // Do anything your heart desires...
                }
                
            case let .failure(error):
                print("data failure \(error.localizedDescription)")
            }
        }
        
    }
    @IBAction func donate(_ sender: Any) {
       let banner = StatusBarNotificationBanner(title: "رقم المطلوب ادخاله : ٥١١٥ / 5115", style: .success)
        banner.show()
    }
    
}
extension String {
    // formatting text for currency textField
    func currencyFormatting() -> String {
        if let value = Double(self) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 2
            if let str = formatter.string(for: value) {
                return str
            }
        }
        return ""
    }
}
