//
//  ViewController.m
//  ObjCEx
//
//  Created by Michael L Mork on 12/15/14.
//  Copyright (c) 2014 Morkrom. All rights reserved.
//

#import "ViewController.h"
#import "ObjCExample-Swift.h"

@interface ViewController () <FormControllerProtocol>

@property (strong, nonatomic) FormController *formController;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    FormBaseObject *formType = [[FormBaseObject alloc] initWithSectionIdx:0 rowIdx:0 numType:1 requiresValidation:YES newKey:@"network key"];
    
    
    formType.identifier = @"TheForm";
    NSArray *formItems = @[formType];
    self.formController = [self newFormController:formItems];
    // Do any additional setup after loading the view, typically from a nib.
}

- (UITextField *)textFieldForFormObject:(id <FormObjectProtocol>)obj aTextField:(UITextField *)aTextField {
    
    if ([obj.identifier isEqualToString:@"TheForm"]) {
        aTextField.placeholder = @"A great example textfield";
    }
    
    return aTextField;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
