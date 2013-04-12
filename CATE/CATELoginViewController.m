//
//  CATELoginViewController.m
//  CATE
//
//  Created by Tom Burnell on 11/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import "CATELoginViewController.h"

@implementation CATELoginViewController

@synthesize userString = _userString;
@synthesize passwordString = _passwordString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
  
  // Create appDelegate for sharing data between views
  appDelegate = [[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginAttempt:(id)sender {
  self.userString = self.user.text;
  self.passwordString = self.password.text;
  
  appDelegate.userAtLogin = self.userString;
  appDelegate.passwordAtLogin = self.passwordString;
  
  
  NSMutableURLRequest *request =
  [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://cate.doc.ic.ac.uk"]];
  [request addValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
  [request setHTTPMethod:@"GET"];
  
  [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];

}


- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
  if([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPBasic])
  {
    return YES;
  } else return NO;
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
  if ([challenge previousFailureCount] == 0) {
    NSURLCredential *creden = [[NSURLCredential alloc] initWithUser:appDelegate.userAtLogin password:appDelegate.passwordAtLogin persistence:NSURLCredentialPersistenceForSession];
    [[challenge sender] useCredential:creden forAuthenticationChallenge:challenge];
  } else {
    // couldn't connect!
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Invalid credentials"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    self.password.text = @"";
  }
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  [self performSegueWithIdentifier:@"LoginToLoading" sender:self];
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
  [super dealloc];
}
@end
