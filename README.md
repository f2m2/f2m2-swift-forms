#FormGenerator

F2M2 Swift FormGenerator is a small collection of Swift files that attempts to flexibly address the need for more dynamic forms powered by your model using protocols and a controller.

You can directly copy the FormGenerator group's contents to your project's directory. 

#Usage

FormGenerator's controller takes form objects on initialization and asks its delegate to configure the basic form types as specified by their model.

You can extend the FormObjectProtocol to your own model and then use the information provided by the FormController to customize your form objects.

When you're finished with your form, FormController has a check validity convenience function as well as a REST form creation function.

#Setup

Setting up the FormViewController is simple:

##1. Create an array of FormObjectProtocol objects: 

Note that the form objects require the Section andIndex This proves convenient later.   

```
let user = FormBaseObject(sectionIdx: 0, rowIdx: 0, type: UIType.TypeTextField)
let password = FormBaseObject(sectionIdx: 0, rowIdx: 1, type: UIType.TypeTextField)

``````
##2. Initialize form controller

The fastest way to start is to use the provided extension on UIViewController:
FormControllerProtocol to instantiate a new formController 
with the FormObjectProtocol-conforming data: 

```
let formController = newFormController([userField, password, dob, register])

``````

This will add a tableview to the viewController and make its edges equal to the viewController's view. 
The tableview can be further configured as it is a property on formController.

#Topics

## Dictionary from data

Setting the key on a FormObjectProtocol conforming object allows the FormController to include it
in the dictionary returned by this: 

```
formController.assembleSubmissionDictionary()
``````

## Validation

A form conforming object can be flagged as requiring validation by setting the optional needsValidation Bool to yes. 

```
*initializing formController's objects

let formObjectWhichNeedsValidation: FormObjectProtocol = formObject()
formObjectWhichNeedsValidation.needsValidation = true

************
************

elsewhere,

func validateForm() {

var formIsValid = formController.validateFormItems({FormObject) -> Bool in 

//formObjectWhichNeedsValidation will be passed as the FormObject.
//Check validation of form item, perform necessary action.
})

if formIsValid = true {

println("Form is valid")
}

``````
## FormControllerProtocol

To customize fields and observe changes to the form data, 
conform the customizing class (a UIViewController in most cases) to the FormControllerProtocol. 
It implements several functions:

### Observe data changes

optional func formValueChanged(obj: FormObjectProtocol) -> ()

### Modify form field items

The concept is the same for the following: a vanilla textfield, switch, or view is passed to the delegate.
You may then use the identifier property (which you set on initialization) of the FormObjectProtocol object to 
identify this item (or replace it entirely with a subclass).  

optional func textFieldForFormObject(obj: FormObjectProtocol, aTextField: UITextField) -> (UITextField?)
optional func switchForFormObject(obj: FormObjectProtocol, aSwitch: UISwitch) -> (UISwitch?)
optional func accompanyingLabel(obj: FormObjectProtocol, aLabel: UILabel) -> (UILabel?)
optional func customViewForFormObject(obj: FormObjectProtocol, aView: UIView) -> (UIView?)

### didSelectFormObject; like didSelectRowAtIndexPath but simpler

optional func didSelectFormObject(obj: FormObjectProtocol) -> ()

##Update Form Data

FormController's FormCell updates the form controller's' data for textfields, buttons, and switches.
To update the value of a FormObjectProtocol of TypeCustomView, you will want to assign it an identifier
and then use the following
FormController's function: 

func updateDataModelWithIdentifier(identifier: String, newValue: AnyObject) 

Example below:


```
//... initialization,

let FormObjectIdentifier = "identifier"

//... 

formObject.identifier = FormObjectIdentifier


//...now wanting to update model,

let arbitraryValue = 100

formController.updateDataModelWithIdentifier(FormObjectIdentifier, arbitraryValue)
``````

##Reload Cell at Row 

Though it is not necessary to reload the FormController's tableview for the default items, 
the capability to reload the cell of the FormObject who's value has changed'



#Objective-C Projects

You can integrate FormController in an Objective-C project... There are configuration steps not currently documented:

1. Add the FormGenerator files to your project. Be sure each file is selected and drag all of them instead of
dragging their containing folder.
Though bothersome, this ensures XCode detects Swift files which prompts you if you wish to create bridging headers. 

2. Say yes  to bridging headers.

3. Navigate to your build target's build settings. Ensure: 

a. "Defines Module" (in Packaging section) is set to Yes.
b. "Embedded Content Contains Swift Code" is set to Yes.

4. Give it a try!


#Acknoledgement

This library uses Cartography.  
https://github.com/robb/Cartography 
