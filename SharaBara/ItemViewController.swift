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
class ItemViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var ShareButton: UIBarButtonItem!
    
    @IBOutlet weak var BackButton: UIBarButtonItem!
    
    var webView: WKWebView!
    //@IBOutlet weak var BackButton: UIBarButtonItem!
    
    var pass: String?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        title = "SharaBara"
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
    }
    
    
 
    
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
        //view.addActivityIndicator()
        loadWebPage()
        
        //for Title
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        
        //BackButton.isEnabled = false
        //BackButton.tintColor = UIColor.clear
 
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
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) { // triggers when loading is complete
        //backButton.isHidden = !webView.canGoBack
        if(webView.canGoBack)
        {
            //BackButton.tintColor = UIColor.blue
            //BackButton.isEnabled = true
        }else{
            //BackButton.isEnabled = false
           // BackButton.tintColor = UIColor.clear

        }
        
        view.removeActivityIndicator()
        
        
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        view.addActivityIndicator()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        view.removeActivityIndicator()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        view.removeActivityIndicator()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        /*
        let loader =   self.loader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.stopLoader(loader: loader)
        }
         */
        
        
    }
    
    @IBAction func BackButtonClicked(_ sender: Any) {
   
        if(webView.canGoBack)
        {
            self.webView.goBack()
        }else{
            self.navigationController?.popViewController(animated:true)

        }
        

    }
    
    
    
    @IBAction func shareButtonClicked(_ sender: UIBarButtonItem) {
   
          //Set the default sharing message.
          //let message = "SharaBara.kz"
          //Set the link to share.
        if let link = NSURL(string: pass!)
          {
              let objectsToShare = [link] as [Any]
              let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
              activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
              self.present(activityVC, animated: true, completion: nil)
          }
      }
    
  
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        if navigationAction.navigationType == .linkActivated  {
        if (url!.absoluteString.range(of: "/item/") != nil  && url!.absoluteString.range(of: "#") == nil){
            decisionHandler(.cancel)
            print(url!)
            
            //let sender: [String: Any?] = ["name": "My name", "id": 10]
            performSegue(withIdentifier: "ItemView2", sender: url!.absoluteString)

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
        if segue.identifier == "ItemView2" {
            if let destinationVC = segue.destination as? ItemViewController2 {
                let PassURL = sender as! String
                destinationVC.pass = PassURL
            }
        }
    }

}

