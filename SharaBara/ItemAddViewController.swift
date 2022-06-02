//
//  ItemViewController.swift
//  SharaBara
//
//  Created by MacBook on 24.05.22.
//

import Foundation


//
//  ViewController.swift
//  SharaBara
//
//  Created by MacBook on 24.05.22.
//

import UIKit
import WebKit
class ItemAddViewController: UIViewController, WKNavigationDelegate {
   
    
    @IBOutlet var webView: WKWebView!

   // var webView: WKWebView!
    //@IBOutlet weak var BackButton: UIBarButtonItem!
    
    var pass: String?
    
    var callBack: ((_ backlink: String)-> Void)?

    
   
    

    
    
 
    
    internal func loadWebPage(fromCache isCacheLoad: Bool = false) {
        let url = URL(string: pass!)
        //print(url as Any)
        guard let url =  url else { return }
        let request = URLRequest(url: url, cachePolicy: (isCacheLoad ? .returnCacheDataElseLoad: .reloadRevalidatingCacheData), timeoutInterval: 50)
            //URLRequest(url: url)
        DispatchQueue.main.async { [weak self] in
            self?.webView.load(request)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        title = "SharaBara"
        loadWebPage()
        
        //for Title
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
 
    }
    
    //for Title
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "title" {
        let delimiter = " - "
        let newstr = webView.title
        let token = newstr!.components(separatedBy: delimiter)
        
            title = token[0]
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        //ShareButton.tintColor = UIColor.systemBlue
        if(webView.canGoBack)
        {
            //BackButton.tintColor = UIColor.blue
            //BackButton.isEnabled = true
        }else{
            //BackButton.isEnabled = false
           // BackButton.tintColor = UIColor.clear

        }
        let css = ".f-footer { display : none !important } .h-header{display : none !important} .l-banner{display : none !important}.b-breadcrumbs{display : none !important}"
               
               let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
               
               webView.evaluateJavaScript(js, completionHandler: nil)
        
        webView.removeActivityIndicator()
        
        
        
    }
    func webViewDidStartLoad(_ webView: WKWebView){
        let css = ".f-footer { display : none !important } .h-header{display : none !important} .l-banner{display : none !important}.b-breadcrumbs{display : none !important}"
               
               let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
               
               webView.evaluateJavaScript(js, completionHandler: nil)
    }
    func webViewDidFinishLoad(_ webView: WKWebView) {
        let css = ".f-footer { display : none !important } .h-header{display : none !important} .l-banner{display : none !important}.b-breadcrumbs{display : none !important}"
               
               let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
               
               webView.evaluateJavaScript(js, completionHandler: nil)
       }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webView.addActivityIndicator()
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webView.removeActivityIndicator()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        webView.removeActivityIndicator()
    }

    override func viewDidAppear(_ animated: Bool) {
 
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
       
        let url = navigationAction.request.url
        if url!.absoluteString.range(of: "/status/") != nil{
            //webView.addActivityIndicator()
            callBack?(url!.absoluteString)
            self.dismiss(animated: true, completion: nil)
        }

        decisionHandler(.allow)


    }
    


}

