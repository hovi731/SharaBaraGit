//
//  ViewController.swift
//  SharaBara
//
//  Created by MacBook on 24.05.22.
//

import UIKit
import WebKit
class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    //ItemViewLink = "";

    var webView: WKWebView!
   

    @IBOutlet weak var BackButton: UIBarButtonItem!
    
    override func loadView() {
        //super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        //view = webView
       // webView.navigationDelegate = self
        //webView = WKWebView()
        
        webView.navigationDelegate = self
        //self.webView.uiDelegate = self
        view = webView
        self.navigationItem.titleView = navTitleWithImageAndText(titleText: "ШараБара", imageName: "Fav")


        
       
    }
    
    internal func loadWebPage(fromCache isCacheLoad: Bool = false) {
        let url = URL(string: "https://sharabara.kz")
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
        loadCookie()
        BackButton.isEnabled = false
        BackButton.tintColor = UIColor.clear
        loadWebPage()
       
    }
    

    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) { // triggers when loading is complete
        //backButton.isHidden = !webView.canGoBack
        view.removeActivityIndicator()
        if(webView.canGoBack)
        {
            BackButton.tintColor = UIColor.blue
            BackButton.isEnabled = true
        }else{
            BackButton.isEnabled = false
            BackButton.tintColor = UIColor.clear

        }
        
        saveCookie()
  
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
    
    
    
    
    @IBAction func BackButtonTapped(_ sender: Any) {
        if(webView.canGoBack)
        {
            self.webView.goBack()
        }else{
            //self.navigationController?.popViewController(animated:true)

        }
        

    }
    
    

    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        //view.addActivityIndicator()
        let url = navigationAction.request.url
        if url!.absoluteString.range(of: "/item") != nil {
            decisionHandler(.cancel)
            print(url!)
            
            //let sender: [String: Any?] = ["name": "My name", "id": 10]
            performSegue(withIdentifier: "ItemView", sender: url!.absoluteString)

            return
        }
        if url!.absoluteString.range(of: "/user") != nil {
            decisionHandler(.cancel)
            print(url!)
            
            //let sender: [String: Any?] = ["name": "My name", "id": 10]
            performSegue(withIdentifier: "UserView", sender: url!.absoluteString)

            return
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
        if segue.identifier == "UserView" {
            if let destinationVC = segue.destination as? UserViewController {
                let PassURL = sender as! String
                destinationVC.pass = PassURL
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //let loader =   self.loader()
       // DispatchQueue.main.asyncAfter(deadline: .now()) {
        //   self.stopLoader(loader: loader)
      //  }
        
        

    }
    
    func navTitleWithImageAndText(titleText: String, imageName: String) -> UIView {

        // Creates a new UIView
        let titleView = UIView()

        // Creates a new text label
        let label = UILabel()
        label.text = titleText
        label.sizeToFit()
        label.center = titleView.center
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "Days", size: 14)
        label.textColor = UIColor(red: 48/255, green: 70/255, blue: 179/255, alpha: 1.0)
        
       

        // Creates the image view
        let image = UIImageView()
        image.image = UIImage(named: imageName)

        // Maintains the image's aspect ratio:
        let imageAspect = image.image!.size.width / image.image!.size.height

        // Sets the image frame so that it's immediately before the text:
        let imageX = label.frame.origin.x - label.frame.size.height
        let imageY = label.frame.origin.y

        let imageWidth = label.frame.size.height * imageAspect
        let imageHeight = label.frame.size.height

        image.frame = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)

        image.contentMode = UIView.ContentMode.scaleAspectFit

        // Adds both the label and image view to the titleView
        titleView.addSubview(label)
        titleView.addSubview(image)

        // Sets the titleView frame to fit within the UINavigation Title
        titleView.sizeToFit()

        return titleView

    }

    
    
    
    
    
}

