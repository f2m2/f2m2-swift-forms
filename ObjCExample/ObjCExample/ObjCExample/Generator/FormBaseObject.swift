//
//  FormButton.swift
//  FormSerializer
//
//  Created by Michael L Mork on 12/4/14.
//  Copyright (c) 2014 f2m2. All rights reserved.
//

import Foundation
import UIKit

 @objc public class FormBaseObject: NSObject, FormObjectProtocol {
    
    public let sectionIdx: Int
    public let rowIdx: Int
    public let displayed: Bool = true
    public let uiType: Int
    public var key: String = ""
    public var reloadOnValueChange: Bool = false

    public var value: AnyObject {
        
        didSet {
            println("value: \(value)")
        }
    }
    
    public var identifier: String = ""
    public var needsValidation: Bool = false
    var titleLabel: String = ""

    
    /*
    init(sectionIdx: Int, rowIdx: Int, type: UIType, validation: Bool, newKey: String) {

        self.sectionIdx = sectionIdx
        self.rowIdx = rowIdx
        self.uiType = type.rawValue
        self.value = true
        self.identifier = ""
        self.key = newKey
        
        super.init()
        
        needsValidation = validation
    }
    
    
    init(sectionIdx: Int, rowIdx: Int, type: UIType) {
        
        self.sectionIdx = sectionIdx
        self.rowIdx = rowIdx
        self.uiType = type.rawValue
        self.value = true
        self.identifier = ""
        
        super.init()
    }
    
    
    
    @objc(initWithSectionIdx:rowIdx:numType:)
    init(sectionIdx: Int, rowIdx: Int, numType: Int) {
        
        self.sectionIdx = sectionIdx
        self.rowIdx = rowIdx
        self.uiType = numType
        self.value = true
        self.identifier = ""
        
        super.init()
    }*/
    
    @objc(initWithSectionIdx:rowIdx:numType:requiresValidation:newKey:)
    init(sectionIdx: Int, rowIdx: Int, type: Int, validation: Bool, newKey: String) {
        
        self.sectionIdx = sectionIdx
        self.rowIdx = rowIdx
        self.uiType = type
        self.value = true
        self.identifier = ""
        self.key = newKey
        
        super.init()
        
        needsValidation = validation
    }
}