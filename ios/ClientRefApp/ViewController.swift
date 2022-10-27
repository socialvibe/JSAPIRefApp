//
//  ViewController.swift
//  ClientRefApp
//
//  Created by Yaro on 9/19/22.
//

import UIKit
import WebKit
import JavaScriptCore
import SafariServices
import AdSupport

class ViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    let config_hash = "#set_this_value"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        if let filePath = Bundle.main.url(forResource: "index", withExtension: "html") {
            
            let contentData = FileManager.default.contents(atPath: filePath.path)
            webView.load(contentData!, mimeType: "html", characterEncodingName: "utf8", baseURL: filePath)
        }
    }
    
    func getIDFA() -> String {
        // Check if Advertising Tracking is Enabled
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            // Set the IDFA
            return ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }
        return "some_default_value"
    }
}

extension ViewController: WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate {
    // Called for messages received by
    // WKWebView message handlers
    func userContentController(_ userContentController: WKUserContentController,didReceive message: WKScriptMessage) {
        
        // The WKScriptMessageHandler name
        // of the sender is message.name
        if message.name == "error" {
            // Parse the response object to obtain the error
            let body = message.body as? [String: Any]
            let error = body?["message"] as? String
            print(error ?? "empty err")
        }
    }
    //Need this to open Web View URLs
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        //if let url = navigationAction.request.url {...}
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }

    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let urlTarget = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        
        if urlTarget.absoluteString.hasPrefix("https") {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "PopupVC") as! PopupVC
            vc.url = urlTarget
            
            let navController = UINavigationController(rootViewController: vc)
            navController.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(navController, animated:true, completion: nil)
            }
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView.evaluateJavaScript("runClient('\(getIDFA())', '\(config_hash)')", completionHandler: nil)
    }
}



