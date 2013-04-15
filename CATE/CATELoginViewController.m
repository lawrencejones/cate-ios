//
//  CATELoginViewController.m
//  CATE
//
//  Created by Tom Burnell on 11/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import "CATELoginViewController.h"
#import "CATEUtilities.h"

@implementation CATELoginViewController

@synthesize userString = _userString;
@synthesize passwordString = _passwordString;


- (id)initWithNibName:(NSString *)nib_name_or_nil
               bundle:(NSBundle *)nib_bunble_or_nil {
  
  self = [super initWithNibName:nib_name_or_nil bundle:nib_bunble_or_nil];
  if (self) {
      // Custom initialization
  }
  return self;
}


- (void)viewDidLoad {
  [super viewDidLoad];
  appDelegate = [[UIApplication sharedApplication] delegate];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (IBAction)loginAttempt:(id)sender {
  // Called when the login button is tapped
  
  self.userString = self.user.text;
  self.passwordString = self.password.text;
  
  appDelegate.userAtLogin = self.userString;
  appDelegate.passwordAtLogin = self.passwordString;
  
  [self toggleLoginFieldsVisibility];
  
  // Ping the CATe server to check whether credentials are correct before
  // loading transitioning to LoadView
  [CATEUtilities initializeConnection:@"https://cate.doc.ic.ac.uk"
                             delegate:self];
}


- (BOOL)connection:(NSURLConnection *)connection
        canAuthenticateAgainstProtectionSpace:
            (NSURLProtectionSpace *)protectionSpace {
  
  if([protectionSpace.authenticationMethod
      isEqualToString:NSURLAuthenticationMethodHTTPBasic]) {
    return YES;
  } else return NO;
}


- (void)connection:(NSURLConnection *)connection
        didReceiveAuthenticationChallenge:
            (NSURLAuthenticationChallenge *)challenge {
  
  if ([challenge previousFailureCount] == 0) {
    NSURLCredential *creden
      = [[NSURLCredential alloc]
            initWithUser:appDelegate.userAtLogin
                password:appDelegate.passwordAtLogin
             persistence:NSURLCredentialPersistenceForSession];

    [[challenge sender] useCredential:creden
           forAuthenticationChallenge:challenge];
    
  } else {
    
    // Failed to authenticate
    [CATEUtilities showAlert:@"Error" message:@"Invalid credentials" delegate:nil cancel_bottom:@"OK"];
    [self toggleLoginFieldsVisibility];
  }
}


- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data {
  
  // Authentication successful
  [self performSegueWithIdentifier:@"LoginToLoading" sender:self];
}


- (void) toggleLoginFieldsVisibility {
  
  if (self.button.alpha == 1) {
    // Everything is active, make it unactive
    
    self.user.enabled = NO;
    self.user.alpha = 0.5;
    
    self.password.enabled = NO;
    self.password.alpha = 0.5;
    
    [self.button setTitle:@"Logging in..." forState:UIControlStateNormal];
    self.button.enabled = NO;
    self.button.alpha = 0.5;
    
  } else {
    // Everything is unactive, make it active
    
    self.user.enabled = YES;
    self.user.alpha = 1;
    
    self.password.text = @"";
    self.password.enabled = YES;
    self.password.alpha = 1;
    
    [self.button setTitle:@"Login" forState:UIControlStateNormal];
    self.button.enabled = YES;
    self.button.alpha = 1;

  }
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
  if (theTextField == self.user ||
      theTextField == self.password) {
    [theTextField resignFirstResponder];
  }
  return YES;
}


- (void)dealloc {
  [_user release];
  [_password release];
  [_user release];
  [_password release];
  [_button release];
  [super dealloc];
}
@end
