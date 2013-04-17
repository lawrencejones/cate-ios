//
//  CATELoginViewController.m
//  CATE
//
//  Created by Tom Burnell on 11/04/2013.
//  ... AND Lawrence Jones. Pfft.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import "CATELoginViewController.h"
#import "CATEUtilities.h"

@implementation CATELoginViewController

@synthesize userString = _userString;
@synthesize passwordString = _passwordString;
@synthesize keyboardToolbar, txtActiveField;

#pragma mark- Initialisation
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
  //self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"stdBg.png"]];
  [self setTextFieldProperties];
  [self createInputAccessoryView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark- Setting UI Properties
- (void)setTextFieldProperties {
  [self.user setBackgroundColor:[UIColor clearColor]];
  [self.user setBorderStyle:UITextBorderStyleNone];
  [self.user setDelegate:self];
  
  [self.password setBackgroundColor:[UIColor clearColor]];
  [self.password setBorderStyle:UITextBorderStyleNone];
  [self.password setDelegate:self];
}


#pragma mark- Text Entry Behaviour
-(void)createInputAccessoryView
{
  self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
  self.keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
  //self.keyboardToolbar.tintColor = [UIColor darkGrayColor];
  
  UIBarButtonItem* previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered target:self action:@selector(gotoPrevTextfield)];
  UIBarButtonItem* nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(gotoNextTextfield)];
  UIBarButtonItem* flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(touchUpMyBody:)];
  
  [self.keyboardToolbar setItems:[NSArray arrayWithObjects: previousButton, nextButton, flexSpace, doneButton, nil]];
  
  [self.user setInputAccessoryView:self.keyboardToolbar];
  [self.password setInputAccessoryView:self.keyboardToolbar];
}


-(void)gotoPrevTextfield
{
  if (self.txtActiveField == self.user)
  {
    return;
  }
  else if (self.txtActiveField == self.password)
  {
    [self.user becomeFirstResponder];
  }
}

-(void)gotoNextTextfield
{
  if (self.txtActiveField == self.user)
  {
    [self.password becomeFirstResponder];
  }
  else if (self.txtActiveField == self.password)
  {
    return;
  }
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  self.txtActiveField = textField;
}

- (IBAction)touchUpMyBody:(id)sender {
  [self.view endEditing:YES];
}


#pragma mark- CATe Connection
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

#pragma mark- NSURLDelegate Methods

- (BOOL)connection:(NSURLConnection *)connection
        canAuthenticateAgainstProtectionSpace:
            (NSURLProtectionSpace *)protectionSpace {
  
  if([protectionSpace.authenticationMethod
      isEqualToString:NSURLAuthenticationMethodHTTPBasic]) {
    return YES;
  } else return NO;
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data {
  // Authentication successful
  [self performSegueWithIdentifier:@"LoginToLoading" sender:self];
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

#pragma mark- Release iVars
- (void)dealloc {
  [_user release];
  [_password release];
  [_user release];
  [_password release];
  [_button release];
  [keyboardToolbar release];
  [txtActiveField release];
  [super dealloc];
}
@end
