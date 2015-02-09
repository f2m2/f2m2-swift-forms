//
//  SettingsViewController.swift
//  ExampleUsage
//
//  Created by Michael L Mork on 12/8/14.
//  Copyright (c) 2014 f2m2. All rights reserved.
//

import Foundation
import UIKit

let LogoutToggle = "LogoutToggle"
let AllowNotifications = "AllowNotis"

class SettingsViewController: UIViewController, FormControllerProtocol {
    
    @IBAction func cancelAction(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var formController: FormController?
    
    func aFormController () -> (FormController) {
        
        let logoutToggle = FormBaseObject(sectionIdx: 0, rowIdx: 0, type: UIType.TypeCustomView)
        logoutToggle.identifier = LogoutToggle
        logoutToggle.reloadOnValueChange = true
        
        
        let viewPrivacyPolicy = FormBaseObject(sectionIdx: 0, rowIdx: 1, type: UIType.TypeCustomView)
        let allowNotifications = FormBaseObject(sectionIdx: 0, rowIdx: 2, type: UIType.TypeASwitch)
        allowNotifications.identifier = AllowNotifications
        let aNewFormController = newFormController([logoutToggle, viewPrivacyPolicy, allowNotifications])
        aNewFormController.tableView.allowsSelection = false

        return aNewFormController
    }
    
    override func viewDidLoad() {
        
        formController = aFormController()
    }
    
    /**
    *******************************
    Use of form generator delegate.
    *******************************
    */
    
    func formValueChanged(obj: FormObjectProtocol) {

        if obj.identifier == AllowNotifications {
            
            NSUserDefaults().setBool(obj.value as Bool, forKey: AllowNotifications)

        }

        println(" formValueChanged: \(obj.value)")
    }
    
    func customViewForFormObject(obj: FormObjectProtocol, aView: UIView) -> (UIView?) {
        
        aView.backgroundColor = UIColor.blackColor()
        
        var button: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), 50)
        button.backgroundColor = UIColor.lightGrayColor()
        
        var selectorStr = "privacyPolicy:"
        var title = "Privacy policy"
        
        if obj.identifier == LogoutToggle {
            
            selectorStr = "logoutToggle:"
            
            let isLoggedIn = NSUserDefaults().boolForKey("isLoggedIn")
            title = isLoggedIn ? "Log out" : "Log in"
        }
        
        button.setTitle(title, forState: UIControlState.Normal)
        button.addTarget(self, action: Selector(selectorStr), forControlEvents: UIControlEvents.TouchUpInside)
        aView.addSubview(button)

        return aView
    }

    func accompanyingLabel(obj: FormObjectProtocol, aLabel: UILabel) -> (UILabel?) {
    
        aLabel.text = "Allow notifications"
        
        return aLabel
    }
    
    //custom actions:
    
    func privacyPolicy(sender: UIButton) {
        
        let webViewController: WebViewController = storyboard?.instantiateViewControllerWithIdentifier("webViewController") as WebViewController//webViewController
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    func logoutToggle(sender: UIButton) {
        
        let isLoggedIn = NSUserDefaults().boolForKey("isLoggedIn")
        formController?.updateDataModelWithIdentifier(LogoutToggle, newValue: !isLoggedIn)
        NSUserDefaults().setBool(!isLoggedIn, forKey: "isLoggedIn")
        NSUserDefaults().synchronize()
        
        if !isLoggedIn {
            
            let userViewController: LoginVC = storyboard?.instantiateViewControllerWithIdentifier("UserViewController") as LoginVC
            
            navigationController?.pushViewController(userViewController, animated: true)
        }
        
    }

   
    
}