//
//  LoginVC.swift
//  ExampleUsage
//
//  Created by Michael L Mork on 12/8/14.
//  Copyright (c) 2014 f2m2. All rights reserved.
//

import Foundation
import UIKit

let PasswordIdentifier = "Password"
let LoginIdentifier = "LoginIdentifier"
let UserIdentifier = "UserIdentifier"

class LoginVC: UIViewController, FormControllerProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    var formController: FormController?

    func aFormController () -> (FormController) {
    
        let userField = FormBaseObject(sectionIdx: 0, rowIdx: 0, type: UIType.TypeTextField)
        let password = FormBaseObject(sectionIdx: 0, rowIdx: 1, type: UIType.TypeTextField, validation: true, newKey: "Password")
        let login = FormBaseObject(sectionIdx: 0, rowIdx: 2, type: UIType.TypeCustomView)

        password.identifier = PasswordIdentifier
        userField.identifier = UserIdentifier
        login.identifier = LoginIdentifier
        
        return newFormController([userField, password, login])
    }

    override func viewDidLoad() {
        
        formController = aFormController()
    }

    
    /**
    *******************************
    Form generator delegate.
    *******************************
    */
    
    func formValueChanged(obj: FormObjectProtocol) {
        
        println(" formValueChanged: \(obj)")
    }
    
    
    func textFieldForFormObject(obj: FormObjectProtocol, aTextField: UITextField) -> (UITextField?) {
        
        println("obj.identifier: \(obj.identifier)")
        
        if obj.identifier == PasswordIdentifier {
                
            aTextField.placeholder = "A secure text field"
            aTextField.secureTextEntry = true
        } else if obj.identifier == UserIdentifier {
            aTextField.placeholder = "User Id"
        }
        
        return aTextField
    }
    
    
    func customViewForFormObject(obj: FormObjectProtocol, aView: UIView) -> (UIView?) {
        
        if obj.identifier == LoginIdentifier {
            
            let registerBtn: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
            
            registerBtn.addTarget(self, action: "loginAction:", forControlEvents: UIControlEvents.TouchUpInside)
            registerBtn.setTitle("Login", forState: UIControlState.Normal)
            registerBtn.frame = CGRectMake(0, 0, 385, 50)
            registerBtn.backgroundColor = UIColor.grayColor()
            aView.addSubview(registerBtn)
        }
        
        return aView
    }
    
    
    /*********************
    Private/Interface
    **********/
    
    func loginAction(sender: AnyObject!) {
        
        let formIsValid = formController?.validateFormItems({ (FormItem) -> Bool in
            
            println("formItem needing validation: \(FormItem)")
            //do validation work here...
            
            return true
        })
    }

    
    @IBAction func cancelAction(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}