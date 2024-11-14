//
//  PrivacyViewController.swift
//  DealShiftStackForge
//
//  Created by DealShiftStackForge on 2024/11/14.
//

import UIKit
import WebKit

class StackForgePrivacyViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var privicyWebView: WKWebView!
    @IBOutlet weak var bgView: UIImageView!
    @IBOutlet weak var topConstants: NSLayoutConstraint!
    @IBOutlet weak var bottomConstants: NSLayoutConstraint!
    
    var adsDatas: [String: Any]?
    @objc var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adsDatas = UserDefaults.standard.value(forKey: "StackForgeADSDataList") as? [String: Any]
        
        initSubViewsConfig()
        initRequest()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let adsDatas = adsDatas {
            if let top = adsDatas["top"] as? NSNumber, top.intValue > 0 {
                topConstants.constant = view.safeAreaInsets.top
            }
            
            if let bot = adsDatas["bot"] as? NSNumber, bot.intValue > 0 {
                bottomConstants.constant = view.safeAreaInsets.bottom
            }
        }
    }
    
    func initSubViewsConfig() {
        activity.hidesWhenStopped = true
        privicyWebView.alpha = 0
        privicyWebView.navigationDelegate = self
        privicyWebView.uiDelegate = self
        privicyWebView.backgroundColor = .black
        privicyWebView.scrollView.backgroundColor = .black
        privicyWebView.scrollView.contentInsetAdjustmentBehavior = .never
    }

    func initRequest() {
        if let urlString = url, !urlString.isEmpty {
            backBtn.isHidden = true
            if let url = URL(string: urlString) {
                activity.startAnimating()
                let request = URLRequest(url: url)
                privicyWebView.load(request)
            }
        } else if let url = URL(string: "https://www.termsfeed.com/live/012176b4-b850-47f4-97e7-231d0d8a5765") {
            privicyWebView.scrollView.contentInsetAdjustmentBehavior = .always
            activity.startAnimating()
            let request = URLRequest(url: url)
            privicyWebView.load(request)
        }
    }
    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.privicyWebView.alpha = 1
            self.activity.stopAnimating()
            self.bgView.isHidden = true
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async {
            self.privicyWebView.alpha = 1
            self.activity.stopAnimating()
            self.bgView.isHidden = true
        }
    }
    
    // MARK: - WKUIDelegate
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil, let url = navigationAction.request.url {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        return nil
    }
}
