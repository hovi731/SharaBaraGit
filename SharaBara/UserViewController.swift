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
class UserViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var ShareButton: UIBarButtonItem!
    
    @IBOutlet var webView: WKWebView!

   // var webView: WKWebView!
    //@IBOutlet weak var BackButton: UIBarButtonItem!
    
    var pass: String?
    
    var check = false
    

    
    
 
    
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
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
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
        check = false
        //ShareButton.tintColor = UIColor.systemBlue
        if(webView.canGoBack)
        {
            //BackButton.tintColor = UIColor.blue
            //BackButton.isEnabled = true
        }else{
            //BackButton.isEnabled = false
           // BackButton.tintColor = UIColor.clear

        }
        let css = ".f-footer { display : none !important } .h-header{display : none !important}"
               
               let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
               
               webView.evaluateJavaScript(js, completionHandler: nil)
        
        webView.removeActivityIndicator()
        
        
        
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
        /*
        let loader =   self.loader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.stopLoader(loader: loader)
        }
         */
        
        
    }
    
    
    
    @IBAction func shareButtonClicked(_ sender: UIBarButtonItem) {
        
        
        check = !check

                if check == true {

                    ShareButton.tintColor = UIColor.gray

                    webView.evaluateJavaScript("document.querySelector('.u-cabinet-aside.d-none.d-md-block').click();")
                            let css = ".u-cabinet-aside.d-none.d-md-block {display: block !important;}"
                            let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
                    webView.evaluateJavaScript(js, completionHandler: nil)
                    
                    //ShareButton.setImage(UIImage(named: "red"), for: .normal)
                } else {
                    ShareButton.tintColor = UIColor.systemBlue
                    webView.evaluateJavaScript("document.querySelector('.u-cabinet-aside.d-none.d-md-block').click();")
                            let css = ".u-cabinet-aside.d-none.d-md-block {display: none !important;}"
                            let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
                    webView.evaluateJavaScript(js, completionHandler: nil)
                    //ShareButton.setImage(UIImage(named: "blue"), for: .normal)
                }


      }
    
  
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        if url!.absoluteString == "https://sharabara.kz/" {
                decisionHandler(.cancel)
                print(url!)
            print("redirect")
                
                //let sender: [String: Any?] = ["name": "My name", "id": 10]
                performSegue(withIdentifier: "GeneralView", sender: url!.absoluteString)

                return
        }
        if url!.absoluteString.range(of: "/user/") != nil{
            //decisionHandler(.cancel)
            ShareButton.isEnabled = false
            ShareButton.tintColor = UIColor.clear
            
            //self.navigationItem.setRightBarButton(nil, animated: true)

            //return
        }
        if url!.absoluteString.range(of: "/cabinet/") != nil{
            //decisionHandler(.cancel)
            ShareButton.isEnabled = true
            ShareButton.tintColor = UIColor.systemBlue
            
            //self.navigationItem.setRightBarButton(nil, animated: true)

            //return
        }
        if navigationAction.navigationType == .linkActivated  {
            if url!.absoluteString.range(of: "/item/edit") != nil || url!.absoluteString.range(of: "/item/add") != nil {
                    decisionHandler(.cancel)
                    print(url!)
                    
                    //let sender: [String: Any?] = ["name": "My name", "id": 10]
                    performSegue(withIdentifier: "ItemAdd", sender: url!.absoluteString)

                    return
                }
            
            
        if (url!.absoluteString.range(of: "/item/") != nil  && url!.absoluteString.range(of: "#") == nil && url!.absoluteString.range(of: "/item/edit") == nil && url!.absoluteString.range(of: "/item/add") == nil){
            decisionHandler(.cancel)
            print(url!)
            
            //let sender: [String: Any?] = ["name": "My name", "id": 10]
            performSegue(withIdentifier: "ItemView", sender: url!.absoluteString)

            return
        }

            
        }
        if navigationAction.request.url?.scheme == "tel" {
            UIApplication.shared.open(navigationAction.request.url!)
            decisionHandler(.cancel)
        }
        
        decisionHandler(.allow)
        //check if host which means website domain like apple.com

        //print(url!)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemView" {
            if let destinationVC = segue.destination as? ItemViewController {
                let PassURL = sender as! String
                destinationVC.pass = PassURL
            }
        }
        if segue.identifier == "GeneralView" {
            if let destinationVC = segue.destination as? ViewController {
                let PassURL = sender as! String
                destinationVC.pass = PassURL
            }
        }
        if segue.identifier == "ItemAdd" {
            if let destinationVC = segue.destination as? ItemAddViewController {
                destinationVC.callBack = { (backlink: String) in
                   // print("segue" ,backlink)
                    let url = URL(string: backlink)!
                    self.webView.load(URLRequest(url: url))
                    //self.webView?.loadRequest(String?,backlink)
                }
                let PassURL = sender as! String
                destinationVC.pass = PassURL
            }
        }
    }


}

