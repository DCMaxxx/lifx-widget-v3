//
//  AppDelegate.swift
//  LIFX Widget
//
//  Created by Maxime de Chalendar on 15/02/2017.
//  Copyright © 2017 DCMaxxx. All rights reserved.
//

import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func applicationDidFinishLaunching(_ application: UIApplication) {
        PersistanceManager.performInitialConfiguration()
        theme(application: application)
    }

}

extension AppDelegate {

    fileprivate func theme(application: UIApplication) {
        let mainColor = #colorLiteral(red: 0.137254902, green: 0.6980392157, blue: 0.7215686275, alpha: 1)

        SVProgressHUD.setBackgroundColor(.white)
        SVProgressHUD.setForegroundColor(mainColor)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setFont(.systemFont(ofSize: 14))

        let navbarAppearance = UINavigationBar.appearance()
        navbarAppearance.barTintColor = .black
        navbarAppearance.tintColor = .white
        navbarAppearance.titleTextAttributes = [ NSForegroundColorAttributeName: UIColor.white ]

        UIToolbar.appearance().barTintColor = .black
        let barButtonItemAppearance = UIBarButtonItem.appearance()
        barButtonItemAppearance.setTitleTextAttributes([
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)], for: .normal)
        barButtonItemAppearance.setTitleTextAttributes([
            NSForegroundColorAttributeName: UIColor.darkGray,
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)], for: .disabled)

        UISlider.appearance().tintColor = mainColor
        UIButton.appearance().tintColor = mainColor
        TargetPickerTableViewCellSelectedView.appearance().tintColor = mainColor

        application.statusBarStyle = .lightContent
    }

}
