//
//  ViewController.swift
//  kbdshortcuts
//
//  Created by l2dy on 3/17/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let textView = MyTextView(frame: view.frame)
        textView.text = "Subject\n\ntest"
        textView.register()
        
        view.addSubview(textView)
    }


}

