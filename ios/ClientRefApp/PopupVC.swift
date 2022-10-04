//
//  PopupVC.swift
//  ClientRefApp
//
//  Created by Yaro on 10/3/22.
//

import UIKit
import SafariServices
import AdSupport
import WebKit

class PopupVC: UIViewController {
    
    var url: URL!

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        webView.load(URLRequest(url: url))
    }
    

    @IBAction func didTapCloseButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
