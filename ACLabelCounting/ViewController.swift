//
//  ViewController.swift
//  ACLabelCounting
//
//  Created by acumen on 17/2/16.
//  Copyright © 2017年 acumen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: ACLabelCounting!
    var count: Int = 0
    let scrollView: UIScrollView = UIScrollView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        label.count(from: 0,
//                    to: 100,
//                    duration: 5,
//                    animationType: .easeIn,
//                    dataType: .double) { txt in
//                return "\(txt) %"
//        }
      
        
        label.count(from: 0,
                    to: 100,
                    duration: 5,
                    animationType: .easeIn,
                    dataType: .int) { text -> NSAttributedString in
                        let appendString = " / 100"
                        let string = "\(text)\(appendString)"
                        let range = (string as NSString).range(of: appendString)
                      
                        let attributedString = NSMutableAttributedString(string: string)
                        attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                                      value: UIColor.lightGray,
                                                      range: range)
                        return attributedString;
        }
    }

    
    @IBAction func startButtonOnClick(_ sender: Any) {
        label.start()
    }
    @IBAction func pauseButtonOnClick(_ sender: Any) {
        if count % 2 == 1 {
            label.restore()
            (sender as! UIButton).setTitle("暂停", for: .normal)
        } else {
            label.pause()
            (sender as! UIButton).setTitle("恢复", for: .normal)
        }
        count = (count + 1) % 2

    }
    
    @IBAction func stopButtonOnClick(_ sender: Any) {
        label.stop()
    }
    
    @IBAction func resetButtonOnClick(_ sender: Any) {
        label.reset()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

