//
//  Exstensions.swift
//  SharaBara
//
//  Created by MacBook on 24.05.22.
//

import Foundation
import UIKit

extension ViewController {
    func loader() -> UIAlertController {
            let alert = UIAlertController(title: nil, message: "Подождите...", preferredStyle: .alert)
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.large
            loadingIndicator.startAnimating()
            alert.view.addSubview(loadingIndicator)
            present(alert, animated: true, completion: nil)
            return alert
        }
        
        func stopLoader(loader : UIAlertController) {
            DispatchQueue.main.async {
                loader.dismiss(animated: true, completion: nil)
            }
        }
    
    func saveCookie() {
        let cookieJar: HTTPCookieStorage = HTTPCookieStorage.shared
        if let cookies = cookieJar.cookies {
            let data: Data = NSKeyedArchiver.archivedData(withRootObject: cookies)
            let ud: UserDefaults = UserDefaults.standard
            ud.set(data, forKey: "cookie")
        }
    }
    
    

    func loadCookie() {
        let ud: UserDefaults = UserDefaults.standard
        let data: Data? = ud.object(forKey: "cookie") as? Data
        if let cookie = data {
            let datas: NSArray? = NSKeyedUnarchiver.unarchiveObject(with: cookie) as? NSArray
            if let cookies = datas {
                for c in cookies {
                    if let cookieObject = c as? HTTPCookie {
                        HTTPCookieStorage.shared.setCookie(cookieObject)
                    }
                }
            }
        }
    }
    
}

extension ItemViewController {
    func loader() -> UIAlertController {
            let alert = UIAlertController(title: nil, message: "Подождите...", preferredStyle: .alert)
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.large
            loadingIndicator.startAnimating()
            alert.view.addSubview(loadingIndicator)
            present(alert, animated: true, completion: nil)
            return alert
        }
        
        func stopLoader(loader : UIAlertController) {
            DispatchQueue.main.async {
                loader.dismiss(animated: true, completion: nil)
            }
        }
    
}

extension UIView {

func addActivityIndicator() {
    //    creating a view (let's call it "loading" view) which will be added on top of the view you want to have activity indicator on (parent view)
    let view = UIView()
    //    setting up a background for a view so it would make content under it look like not active
    view.backgroundColor = UIColor.white.withAlphaComponent(1)

    //    adding "loading" view to a parent view
    //    setting up auto-layout anchors so it would cover whole parent view
    self.addSubview(view)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
    view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true

    //    creating array with images, which will be animated
    //    in my case I have 30 images with names activity0.png ... activity29.png
    var imagesArray = [UIImage(named: "loading\(0)")!]
    for i in 1..<50 {
        imagesArray.append(UIImage(named: "loading\(i)")!)
    }

    //    creating UIImageView with array of images
    //    setting up animation duration and starting animation
    let activityImage = UIImageView()
    activityImage.animationImages = imagesArray
    activityImage.animationDuration = TimeInterval(1.1)
    activityImage.startAnimating()

    //    adding UIImageView on "loading" view
    //    setting up auto-layout anchors so it would be in center of "loading" view with 30x30 size
    view.addSubview(activityImage)
    activityImage.translatesAutoresizingMaskIntoConstraints = false
    activityImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    activityImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    activityImage.widthAnchor.constraint(equalToConstant: 120).isActive = true
    activityImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
}

func removeActivityIndicator() {
    //    checking if a view has subviews on it
    guard let lastSubView = self.subviews.last else { return }
    //    removing last subview with an assumption that last view is a "loading" view
    lastSubView.removeFromSuperview()
} }



extension UserDefaults {
    
    class func setURLToContinue(urlString: String){
        UserDefaults.standard.set(urlString, forKey: "continueURL")
    }
    
    class func getURLToContinue() -> String? {
        return UserDefaults.standard.string(forKey: "continueURL")
    }
    
    class func removeURLToContinue(){
        UserDefaults.standard.removeObject(forKey: "continueURL")
    }
    
}

extension UIApplication
{
    static func getKeyWindow() -> UIWindow? {
        return shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
    }
}
