//
//  CATELoginViewController.h
//  CATE
//
//  Created by Tom Burnell on 11/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CATELoadViewController.h"

@interface CATELoginViewController : UIViewController
<UITextFieldDelegate> {
  CATEAppDelegate *appDelegate;
}

@property (retain, nonatomic) IBOutlet UITextField *user;
@property (retain, nonatomic) IBOutlet UITextField *password;

@property (copy, nonatomic) NSString *userString;
@property (copy, nonatomic) NSString *passwordString;
@property (retain, nonatomic) IBOutlet UIButton *button;




- (IBAction)loginAttempt:(id)sender;

@end
