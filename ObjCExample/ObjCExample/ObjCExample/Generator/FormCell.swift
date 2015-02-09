//
//  FormCell.swift
//  FormSerializer
//
//  Created by Michael L Mork on 12/2/14.
//  Copyright (c) 2014 f2m2. All rights reserved.
//

import Foundation
import UIKit

let addedViewTag = 150
let addedLabelTag = 160

/**
    FormCell needed to be subclassed in order to callback when text changes, allowing a change of the model and update to the cell's interface.
*/

class FormCell: UITableViewCell, UITextFieldDelegate {
    
    //Typealias is similar to typedef from objective-C.
    
    var valueDidChange: FieldDidChange?
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        valueChange(textField.text)
        
        return true
    }
    
    func valueChange(anyObject: AnyObject) {
        
        if let valueChange = valueDidChange as FieldDidChange? {
            
            valueChange(value: anyObject)
        }
    }
    
    func setState(value: UISwitch) {

        println("the switch: \(value) \n\n\n")
        
        valueChange(value.on)
    }
    
    func btnTouch(btn: UIButton) {
       
        valueChange(btn)
    }
    
    func removeTagView() {
        
        if let view = contentView.viewWithTag(addedViewTag) as UIView! {
            view.removeFromSuperview()
        }
        
        if let view = contentView.viewWithTag(addedLabelTag) as UILabel! {
            view.removeFromSuperview()
        }
    }
}

/**
    This extension exists because of the possibility (but not currently it seems) support for setting a function as an associated object on the cell.
    When this possibility is apparent, there will be no need to subclass UITableViewCell. The function in question is Form Cell's "valueDidChange" variable.
*/

extension FormCell {
    
    func addTextField (textField: UITextField?) {
        
        removeTagView()
        
        var theTextField = textField
        if let textField = textField as UITextField! {} else {
            theTextField = UITextField(frame: CGRectMake(0, 30, 100, 40))
            theTextField!.borderStyle = UITextBorderStyle.RoundedRect
        }
        
        contentView.addSubview(theTextField!)
        
        layout(theTextField!, contentView) { (TextField, backgroundOutlet) -> () in
            
            TextField.width == backgroundOutlet.width - 30
            TextField.center == backgroundOutlet.center
            
            return()
        }
        
        theTextField!.delegate = self
        
        self.layoutIfNeeded()
        
        theTextField!.tag = addedViewTag
    }
    
    func addSwitch(label: UILabel?, aSwitch: UISwitch?) {
        
        removeTagView()
        var aSwitch = aSwitch
        
        if let aSwitch = aSwitch as UISwitch! {} else {
            
            let newSwitch = UISwitch()
            aSwitch = newSwitch
        }

        contentView.addSubview(aSwitch!)
        
        ///If the label was passed then add it to the cell; otherwise center the solitary switch
        
        if let label = label as UILabel! {

            contentView.addSubview(label)

            layout(aSwitch!, label, contentView) {(TheSwitch, TheLabel, ContentView) -> () in
            
                TheLabel.width == ContentView.width - 80
                TheLabel.centerX == ContentView.centerX - 30
                TheLabel.centerY == ContentView.centerY
                TheSwitch.leading == TheLabel.trailing + 10
                TheSwitch.centerY == TheLabel.centerY
                
                return()
            }
            
        } else {
            
            layout(aSwitch!, contentView) {(TheSwitch, ContentView) -> () in
                
                TheSwitch.center == ContentView.center
                return()
            }
        }
        
        aSwitch!.addTarget(self, action: "setState:", forControlEvents: UIControlEvents.ValueChanged)
        aSwitch!.tag = addedViewTag
    }
    
    func addButton(button: UIButton?) {
        
        removeTagView()
        
        var button = button
        if let button = button as UIButton? {} else {
            
            let newButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
            newButton.setTitle("Submit", forState: UIControlState.Normal)
            button = newButton
        }
        
        contentView.addSubview(button!)
        
        layout(button!, contentView) {(button, ContentView) -> () in
            
            button.edges == inset(ContentView.edges, 20, 20, 20, 20); return
        }
        
        button!.addTarget(self, action: "btnTouch:", forControlEvents: UIControlEvents.TouchUpInside)
        button!.tag = addedViewTag
    }
    
    func addCustomView(view: UIView?) {
        
        removeTagView()
        
        if let view = view as UIView? {
            
            contentView.addSubview(view)
            layout(view, contentView) {(View, ContentView) -> () in
                
                View.edges == inset(ContentView.edges, 0, 0, 0, 0); return
            }
        }
        
    }
}
