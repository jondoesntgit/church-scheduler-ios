//
//  NavigationUtilities.swift
//  ChurchScheduler
//
//  Created by Jonathan Wheeler on 6/9/19.
//  Copyright © 2019 Jonathan Wheeler. All rights reserved.
//

import UIKit

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? navcon
        } else {
            return self
        }
    }
}
