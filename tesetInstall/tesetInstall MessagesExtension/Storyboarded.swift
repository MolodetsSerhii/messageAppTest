//
//  Storyboarded.swift
//  tesetInstall MessagesExtension
//
//  Created by Serhii Molodets on 25.09.2023.
//

import UIKit

extension UIViewController {
    class var storyboardID: String {
        return "\(self)"
    }
    
    static func instantiateFrom(appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
}

enum AppStoryboard: String {
    case compact = "Compact"
    case expanded = "Expanded"
   
    
    var instance: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: nil)
    }
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardID = (viewControllerClass as T.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
}
