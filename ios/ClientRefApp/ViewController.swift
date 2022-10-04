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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controller = webView?.configuration.userContentController
        
        controller?.add(self, name: "error")
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        if let filePath = Bundle.main.url(forResource: "index", withExtension: "html") {
            
            let contentData = FileManager.default.contents(atPath: filePath.path)
            let emailTemplate = NSString(data: contentData!, encoding: String.Encoding.utf8.rawValue) as? String
            //Set network_user_id to apple adv ID
            let replacedHtmlContent = emailTemplate?.replacingOccurrences(of: "@%", with: getIDFA() ?? "")
            let replacedHtmlData = replacedHtmlContent?.data(using: .utf8)
            
            webView.load(replacedHtmlData!, mimeType: "html", characterEncodingName: "utf8", baseURL: filePath)
        }
    }
    
    func getIDFA() -> String? {
        // Check if Advertising Tracking is Enabled
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            // Set the IDFA
            return ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }
        return nil
    }
    
}

extension ViewController: WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate {
    // Called for messages received by
    // WKWebView message handlers
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage) {
            
            // The WKScriptMessageHandler name
            // of the sender is message.name
            if message.name == "error" {
                // Parse the response object to obtain the error
                let body = message.body as? [String: Any]
                let error = body?["message"] as? String
                print(error ?? "empty err")
            }
        }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        let exceptions = SecTrustCopyExceptions(serverTrust)
        SecTrustSetExceptions(serverTrust, exceptions)
        completionHandler(.useCredential, URLCredential(trust: serverTrust));
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
            completionHandler()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - confirm
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
    }
    
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
}



