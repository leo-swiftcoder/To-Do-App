//
//  Alerts.swift
//  To Do App
//
//  Created by Apple on 02/10/21.
//


import Foundation
import UIKit
class Alerts{
    class func showSelfDismissedAlertView(title: String?, message: String?, view: UIViewController?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.presentInOwnWindow(animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
    class func goBackAlert(view: UIViewController, title:String, message:String, navController : UINavigationController?) {
        
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            if let navController = navController {
                navController.popViewController(animated: true)
            }else{
                view.dismiss(animated: true, completion: nil)
            }
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        
        //finally presenting the dialog box
        view.present(alertController, animated: true, completion: nil)
        
    }
    
    class func displayAlertWithCompletion(title:String, confirmTitle: String, cancelTitle: String, message:String, completion: @escaping (Bool) -> Void) {
        
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { (_) in
            completion(true)
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .default) { (_) in
            completion(false)
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        alertController.presentInOwnWindow(animated: true, completion: nil)
        
    }
    
    class func displayAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        alertController.presentInOwnWindow(animated: true, completion: nil)
        
    }
    
}
extension UIAlertController {
    
    func presentInOwnWindow(animated: Bool, completion: (() -> Void)?) {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(self, animated: animated, completion: completion)
    }
}
