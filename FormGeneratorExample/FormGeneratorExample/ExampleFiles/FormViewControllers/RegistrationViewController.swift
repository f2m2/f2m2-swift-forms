//
//  RegistrationViewController.swift
//  ExampleUsage
//
//  Created by Michael L Mork on 12/8/14.
//  Copyright (c) 2014 f2m2. All rights reserved.
//

import Foundation
import UIKit

let DatePickerIdentifier = "DatePicker"
let SecureField = "SecureField"
let UsrField = "UsrField"
let RegisterBtn = "RegisterBtn"

class RegistrationViewController: UIViewController, FormControllerProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    var formController: FormController?
    
    func aFormController () -> (FormController) {
        
        let userField = FormBaseObject(sectionIdx: 0, rowIdx: 0, type: UIType.TypeTextField)
        userField.key = "userField"

        let password = FormBaseObject(sectionIdx: 0, rowIdx: 1, type: UIType.TypeTextField)
        password.identifier = SecureField
        password.needsValidation = true
        password.key = "password"
        
        let dob = FormBaseObject(sectionIdx: 1, rowIdx: 0, type: UIType.TypeCustomView)
        dob.identifier = DatePickerIdentifier
        dob.key = "dateOfBirth"

        let register = FormBaseObject(sectionIdx: 1, rowIdx: 1, type: UIType.TypeCustomView)
        register.identifier = RegisterBtn
        
        let formController = newFormController([userField, password, dob, register])
        formController.sectionHeaderTitles = ["Email, password", "Whats your birthday?"]
        formController.tableView.allowsSelection = false
        
        return formController
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
        
        if obj.identifier == SecureField {
            
            aTextField.secureTextEntry = true
            aTextField.placeholder = "A secure text field"
        } else if obj.identifier == UsrField {
            aTextField.placeholder = "User name"
        }
        
        return aTextField
    }
    
    func actionBtnForFormObject(obj: FormObjectProtocol) -> (UIButton?) {
        
        if obj.sectionIdx == 1 {
            
            let button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
            button.backgroundColor = UIColor.redColor()
            button.setTitle("CustomButton", forState: UIControlState.Normal)
            
            return button

        } else {

            return nil
        }
    }
    
    func customViewForFormObject(obj: FormObjectProtocol, aView: UIView) -> (UIView?) {
        
        if obj.identifier ==  DatePickerIdentifier {
            //add date picker picker
            
            let datePickerButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
            datePickerButton.addTarget(self, action:"fireDatePicker:", forControlEvents: UIControlEvents.TouchUpInside)
            datePickerButton.frame = CGRectMake(0, 0, 385, 44)
            datePickerButton.setTitle("Set DOB", forState: UIControlState.Normal)
            datePickerButton.backgroundColor = UIColor.lightGrayColor()
            
            aView.addSubview(datePickerButton as UIButton)
         }

        if obj.identifier == RegisterBtn {
            
            let registerBtn: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton

            registerBtn.addTarget(self, action: "registerAction:", forControlEvents: UIControlEvents.TouchUpInside)
            registerBtn.setTitle("Finished", forState: UIControlState.Normal)
            registerBtn.frame = CGRectMake(0, 0, 385, 50)
            registerBtn.backgroundColor = UIColor.grayColor()
            aView.addSubview(registerBtn)
        }
          
        return aView
    }
    
    
    /*********************
    Private/Interface
    **********/
    
    func registerAction(sender: AnyObject!) {
    
        let formIsValid = formController?.validateFormItems({ (FormItem) -> Bool in

            println("formItem needing validation: \(FormItem)")
            //do validation work here...

            return true
        })

        if formIsValid as Bool! == true {

            println("assembledSubmissionDictionary: \(formController?.assembleSubmissionDictionary())")
        }
        
        
    }
    
    func fireDatePicker(sender: AnyObject!) {
        
        let datePicker = UIDatePicker()
        
        let datePickerView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame)))
        datePickerView.backgroundColor = UIColor.whiteColor()
        datePickerView.addSubview(datePicker)
        
        let datePickerButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        datePickerButton.addTarget(self, action: "removePickerView:", forControlEvents: UIControlEvents.TouchUpInside)
        datePickerButton.setTitle("Finished", forState: UIControlState.Normal)
        datePickerButton.frame = CGRectMake(0, 200, 385, 50)
        datePickerButton.backgroundColor = UIColor.grayColor()
        datePickerView.addSubview(datePickerButton)
        
        datePicker.tag = 100
        datePickerView.tag = 14000
        view.addSubview(datePickerView)
    }
    
    
    /**
    Private
    */
    
    func removePickerView (sender: UIButton) {
        
        let pickerView = view.viewWithTag(14000) as UIView!
        let datePicker = pickerView.viewWithTag(100) as UIDatePicker
        
        formController?.updateDataModelWithIdentifier(DatePickerIdentifier, newValue: datePicker.date)
        pickerView.removeFromSuperview()
        //set form model to picker current date
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

}