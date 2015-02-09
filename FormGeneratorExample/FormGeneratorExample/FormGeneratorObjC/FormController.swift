//
//  FormSerializerClasses.swift
//  FormSerializer
//
//  Created by Michael L Mork on 12/1/14.
//  Copyright (c) 2014 f2m2. All rights reserved.
//

import Foundation
import UIKit

/**
    Simple convenience extensions on FormControllerProtocol-conforming UIViewController; tableview is provided and added.
*/

extension UIViewController: FormControllerProtocol {
    
    /**
        Convenience on convenience; provide only the form data data.
        :param: data FormObjectProtocol-conforming objects.
        :return: FormController a formController.
    */

    public func newFormController (data: [FormObjectProtocol]) -> FormController {
        return newFormController(data, headerView: nil)
    }
    
    /**
        Provide data and a header view for a tableview which is added to self.
        :param: data FormObjectProtocol-conforming objects.
        :param: headerView an optional custom header for the tableView
        :return: FormController a formController.
    */
    
    public func newFormController (data: [FormObjectProtocol], headerView: UIView?) -> FormController {
        
        let tableView = UITableView(frame: CGRectZero)

        view.addSubview(tableView)
        
        layout(tableView, view) { (TableView, View) -> () in
            
            TableView.edges == inset(View.edges, 20, 0, 0, 0); return
        }

        if let headerView = headerView as UIView! {
            
            tableView.tableHeaderView = headerView
        }
        
        let formController = FormController(data: data, tableView: tableView)
        
        formController.delegate = self
        
        return formController
    }
}

/**

The EntityController holds the FormSerializationProtocol collection.
It sorts this collection in order to find the data which will be displayed.
It sorts to find the number of sections.
It sets its displayed data values as the interface is manipulated.

Meant-For-Consumption functions include:

/// - init: init with FormSerializationProtocol-conforming objects.
/// - validateForm: Validate all FormObjectProtocol objects which implement isValid().
/// - assembleSubmissionDictionary: Assemble a network SubmissionDictionary from the values set on the display data which are implementing the key variable in FormObjectProtocol.
/// - updateDataModelWithIdentifier: Update a FormObjectProtocolObject with a value and its user - given identifier.

*/

 @objc public class FormController: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    
    
    let data: [FormObjectProtocol]
    var delegate: FormControllerProtocol?
    var tableView: UITableView
    var customFormObjects: [String: FormObjectProtocol] = [String: FormObjectProtocol]()
    var sectionHeaderTitles: [String] = [String]()

    
    
    
    lazy var displayData: [FormObjectProtocol] = {
        
        var mData = self.data
        
        mData = sorted(mData) {
            
            f0, f01 in
            
            //Display order here.
            return f0.rowIdx < f01.rowIdx
        }
        
        var nData = mData.filter { (T) -> Bool in
            
            //filter whether to display here.
            T.displayed == true
        }
        
        return nData
        
        }()
    
    
    
    
    
    /********
    public
    ********/
    
    /**
        init with data  conforming to the FormSerializationProtocol.
        :param: data An array of objects conforming to the FormSerializationProtocol
        :returns: self
    */
    
     init(data: [FormObjectProtocol], tableView: UITableView) {
        
        self.data = data
        self.tableView = tableView
        
        super.init()
        
        tableView.registerClass(FormCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    /**
        Update the data model with identifier and the new value.
        :param: identifier A string assigned to a given
        :param: newValue Whatever type of anyObject the user desires to set on the given identifier's FormObjectProtocol object.
    */
    
    func updateDataModelWithIdentifier(identifier: String, newValue: AnyObject) {
        
       // if let formObject = customFormObjects?[identifier] as FormObjectProtocol? {
        println("update data model: \(customFormObjects)")
        updateDataModel(customFormObjects[identifier])
    }
    
    
    /**
        Update the data model with a unique ForhObjectProtocol object.
        :param: object A FormObjectProtocol object
    */
    
    func updateDataModel(object: FormObjectProtocol?) {
        
        if let object = object as FormObjectProtocol? {
            
            let index = collectionIndexOfObjectInSection(object.rowIdx, itemIndexInSection: object.sectionIdx)
        
            self.displayData.removeAtIndex(index)
            self.displayData.insert(object, atIndex: index)

            /*
            This is an example of optional chaining.
            The delegate may or may not exist (an optional), and it may or may not be implementing formValueChanged.
            This is what the question marks are delineating.
            */
            self.delegate?.formValueChanged?(object)
            
            let indexPath = NSIndexPath(forRow: object.rowIdx, inSection: object.sectionIdx)

            
            if object.reloadOnValueChange == true {

                println("\n reloading index at row: \n\n indexPath row: \(indexPath.row) \n indexPath section: \(indexPath.section) \n\n")

                tableView.reloadRowsAtIndexPaths([indexPath as NSIndexPath], withRowAnimation: UITableViewRowAnimation.None)
            }

            //tableView.reloadData()
        }
    }

    
    /**
        Check form objects implementing this method for being valid
        :return: An array of validation error strings to be presented however the user wishes.
    */
    
    func validateFormItems(formItemIsValid: FieldNeedsValidation) -> (Bool) {
        
        var isValid = true

        var dataThatValidates = data.filter { (filtered: FormObjectProtocol) -> Bool in
            
            filtered.needsValidation == true
        }
        
        for protocolObject in dataThatValidates {
            
            if let formIsValid = formItemIsValid(value: protocolObject) as Bool? {

                if formIsValid == false {
                    isValid = false
                }
            }
        }
        
        return isValid
    }
    
    
    /**
        Assemble a urlRequest form dictionary.
        :return: a urlRequest form dictionary.
    */
    
    func assembleSubmissionDictionary() -> NSDictionary {
        
        var nData = data.filter { (FieldObject) -> Bool in
         
            //Get data which is not being displayed; its value is required and already provided.
            
            FieldObject.displayed == false
        }
        
        //Append the display data to nData.
        nData += displayData
        
        var filteredData =  nData.filter { (T) -> Bool in
            
            var hasKey = false
            
            if let keyAsString = T.key as String? {
                
                if countElements(keyAsString) > 0 {
                    hasKey = true
                }
            }
            
            return hasKey == true
        }
        
        let mDict: NSMutableDictionary = NSMutableDictionary()
        
        for kV in filteredData {
            
            mDict.setValue(kV.value, forKey: kV.key)
        }
        
        

        return mDict.copy() as NSDictionary
    }
    
    
    
    
    /********
    private
    ********/
    
    
    
    /**
        Compute number of sections for the data.
    
        :return: number of sections for the data.
    */
    
    private func numberOfSections() -> (Int) {
        
        var prevIdx = 0
        var mSectionsCount: NSMutableDictionary = NSMutableDictionary()
        for data in displayData {
            
            var numSectionsForIdx = mSectionsCount[String(data.sectionIdx)] as Int!
            
            if let sectionsCount = numSectionsForIdx as Int! {
                
                var section = sectionsCount
                mSectionsCount.setValue(++section, forKey: String(data.sectionIdx))
                
            } else {
                
                mSectionsCount.setValue(0, forKey: String(data.sectionIdx))
            }
            
            ++prevIdx
        }
        
        return mSectionsCount.allKeys.count
    }
    
    func numberOfItemsInSection(section: Int) -> (Int) {
        
        return displayDataForSection(section).count
    }
    
    /**
        Called in CellForRowAtIndexPath.
    
        :param: FormCell The cell to configure to display its data for the display data for section and row.
        :param: NSIndexPath Pretty standard, really.
    */
    
   private func formCellForRowAtIndexPath(cell: UITableViewCell, indexPath: NSIndexPath) {
        
        if let cell = cell as? FormCell {
            
            let displayData = displayDataForSection(indexPath.section)
            
            //A sanity check
            if indexPath.row < displayData.count {
                
                var field = displayData[indexPath.row]
                
                requestViewObject(field, cell: cell, {value in
                    
                    /*
                    Upon a value change, set the field's value to the new value and replace the current model's object.
                    */
                    
                    field.value = value
                    self.updateDataModel(field)
                })
            }
            
        }
    }
    
    /**
        Filter the display data for the corresponding section.

        :param: The section idx.
        :returns: Array of
    */
    
    private func displayDataForSection(sectionIdx: Int) -> ([FormObjectProtocol]) {
        
        var dataForSection = displayData.filter { (T) -> Bool in

            return T.sectionIdx == sectionIdx
        }
        
        dataForSection = dataForSection.sorted { (previous, current) -> Bool in
            previous.rowIdx < current.rowIdx
        }
        
        return dataForSection
    }
    
    
    
    
    
    /**
        Determine the enum then call the associated function, passing an optional UI element. (the cell will create one on its own otherwise)

        :param: FormObjectProtocol: an FOP conforming object
        :param: FormCell: a form cell
        :param: ValueDidChange:
    */
    
   private func requestViewObject(field: FormObjectProtocol, cell: FormCell, valueChangeCallback: FieldDidChange) {
        
        //update the custom field values
        if let fieldId = field.identifier as String! {
            
            if fieldId != "" {
                
                customFormObjects.updateValue(field, forKey: fieldId)
                
                println("field added to customFormObjects: \(customFormObjects)")
            }
        }
        
        let type = UIType(rawValue: field.uiType)
        
                switch type! {
                
                case .TypeNone:
                    return
                    
                case .TypeTextField:
                
                    cell.addTextField(delegate?.textFieldForFormObject?(field, aTextField: UITextField()))
                
                case .TypeASwitch:
                    
                    println("switch value bein set to: \(field.value)")

                    let aNewSwitch = UISwitch()
                    aNewSwitch.setOn(field.value as Bool, animated: true)
                    
                    cell.addSwitch(delegate?.accompanyingLabel?(field, aLabel: UILabel()), aSwitch: delegate?.switchForFormObject?(field, aSwitch: aNewSwitch))
        
                case .TypeCustomView:
                    
                    cell.addCustomView(delegate?.customViewForFormObject?(field, aView: UIView()))
                }
        
        cell.valueDidChange = valueChangeCallback
    }
    
    private func collectionIndexOfObjectInSection(section: Int, itemIndexInSection: Int) -> (Int) {
        
        let map = sectionsMap()
        var totalCount = 0
        
        for key in map.allKeys {
            
            let count = key.integerValue
            let sectionIdx = map[String(key as NSString)] as Int
            
            if sectionIdx < section {
                totalCount += count
            }
            
            if sectionIdx == section {
                totalCount += itemIndexInSection
            }
        }
        
        return totalCount
    }
    
    
    private func sectionsMap () -> (NSDictionary) {
        
        var prevIdx = 0
        var mSectionsCount: NSMutableDictionary = NSMutableDictionary()
        
        for data in displayData {
            
            var numSectionsForIdx = mSectionsCount[String(data.sectionIdx)] as Int!
            
            if let sectionsCount = numSectionsForIdx as Int! {
                
                var section = sectionsCount
                mSectionsCount.setValue(++section, forKey: String(data.sectionIdx))
                
            } else {
                
                mSectionsCount.setValue(0, forKey: String(data.sectionIdx))
            }
            
            ++prevIdx
        }
        
        return mSectionsCount.copy() as NSDictionary
    }
    
    
    
    
    /*
    **************************
    tableView delegate methods
    **************************
    */
    
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return numberOfItemsInSection(section) // filteredArrayCount
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return numberOfSections()
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: AnyObject? = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        formCellForRowAtIndexPath(cell as UITableViewCell, indexPath: indexPath)
        
        return cell as UITableViewCell
        
    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var title = ""
        if section < sectionHeaderTitles.count {
            title = sectionHeaderTitles[section]
        }
        
        return title
    }
    
     public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let displayData = displayDataForSection(indexPath.section)
        
        //A sanity check
        if indexPath.row < displayData.count {
            
            var field = displayData[indexPath.row]
            delegate?.didSelectFormObject?(field)
        }
    }

}
