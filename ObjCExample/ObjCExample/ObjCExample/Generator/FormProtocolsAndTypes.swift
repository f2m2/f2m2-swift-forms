//
//  FormProtocols.swift
//  FormSerializer
//
//  Created by Michael L Mork on 12/5/14.
//  Copyright (c) 2014 f2m2. All rights reserved.
//

import Foundation







/*********

* enums and typealiases *

**********/

/**
    FormProtocol type aliases:

    /// - ValueDidChange: a function which receives AnyObject; this function is used by the FormCell to communicate to the FormController any changes to the model object values.
    /// - ValidationErrorString:
*/

typealias FieldDidChange = (value: AnyObject) -> ()
typealias FieldNeedsValidation = (value: FormObjectProtocol) -> (Bool)
typealias ValidationErrorString = String

/**
    The FormField item type.
    It represents the interface choice available to the model that adopts the FormSerializationProtocol
    Currently its values are:

    /// - TypeNone
    /// - TypeTextField
    /// - TypeASwitch
    /// - TypeCustomView
*/

 public enum UIType: Int {
    
    case TypeNone = 0
    case TypeTextField
    case TypeASwitch
    case TypeCustomView
}








/*********

FormProtocols

*********/

import UIKit




@objc public protocol FormObjectProtocol {
    
    /**
    
    The protocol adopted by the form objects.
    
    Listed are the required objects:
    
    // - uiType: The type of interface object needs to be represented.
    // - value: The value of the form item in question this is set in the EntityController as the user changes.
    // - sectionIdx: The section of the item. Default to 0.
    // - rowIdx: The form entity's position in its section.
    // - displayed: Is this item to be displayed?
    
    Optional variables and functions:
    
    // - key: If you plan to serialize this object into a url request form, this is the key for that purpose.
    // - identifier: Use to identify specific FormObjects being passed in FormControllerProtocol methods. Also use it to update the FormController's model.
    // - needsValidation: Bool marking object to be checked for validity.
    
    */
    
    var uiType: Int { get }/// objc protocol will not allow direct use of a swift enum.
    var value: AnyObject { get set }
    var sectionIdx: Int { get }
    var rowIdx: Int { get }
    var displayed: Bool { get }
    var identifier: String { get }
    var key: String { get }
    optional var needsValidation: Bool { get }
    optional var reloadOnValueChange: Bool { get }
}





@objc public protocol FormControllerProtocol {
    
    /**
        The protocol adopted by the whatever object desires to provide custom UI elements, as well as the formValueChanged function.
        The return values of the following are all optional. If no return value is generated, a default implementation of the given type is generated.
    */
    
    /**
        Notifies self of the form object who's value has changed.
        :param: obj A form object.
    */
    
    optional func formValueChanged(obj: FormObjectProtocol) -> ()
    
    /**
        These are best explained as optional cell-for-row-at-index-path functions but only for the views corresponding to their type. 
        Make your changes to the items or replace them altogether.
        The return values are optional because the default implementation will take over if no custom item is provided.
        
        :param: FormObjectProtocol
        :param: UIView/UIControl A given UIView or UIControl.
        
        :return: optional interface element.
    */
    
    optional func textFieldForFormObject(obj: FormObjectProtocol, aTextField: UITextField) -> (UITextField?)
    optional func switchForFormObject(obj: FormObjectProtocol, aSwitch: UISwitch) -> (UISwitch?)
    
    /**
        The label is currently only implemented side-by-side with the switch. Using a tuple to pair switch and UILabel was not an option for @objc protocol.
    */
    optional func accompanyingLabel(obj: FormObjectProtocol, aLabel: UILabel) -> (UILabel?)
    
    /**
        A caveat with the custom view is that in order to update the value on the FormObjectProtocol object (as well as to recognize which object it is), it is wise to set and check the identifier on the FormObjectProtocol.
    */
    
    optional func customViewForFormObject(obj: FormObjectProtocol, aView: UIView) -> (UIView?)
    
    /**
        A more concise didSelectCell.
    */
    optional func didSelectFormObject(obj: FormObjectProtocol) -> ()
}




















