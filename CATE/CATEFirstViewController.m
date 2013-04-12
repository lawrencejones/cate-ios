//
//  CATEFirstViewController.m
//  CATE
//
//  Created by Tom Burnell on 11/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import "CATEFirstViewController.h"

@interface CATEFirstViewController ()

@end

@implementation CATEFirstViewController

- (void)changeNameLabel:(NSString *)name {
  if ([name length] == 0) {
    self.nameLabel.text = @"Placeholder name";
  } else {
    self.nameLabel.text = name;
  }
}

- (void)changeLoginLabel:(NSString *)login {
  if ([login length] == 0) {
    self.loginLabel.text = @"Placeholder login";
  } else {
    self.loginLabel.text = login;
  }
}

- (void)changePhoto:(UIImage *)photo {
  self.photoImage.image = photo;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
  // Create appDelegate for sharing data between views
  appDelegate = [[UIApplication sharedApplication] delegate];
  [self changeNameLabel:appDelegate.identity.fullName];
  [self changeLoginLabel:appDelegate.identity.login];
  
  NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:
                                                   [@"https://cate.doc.ic.ac.uk/"stringByAppendingString:appDelegate.identity.profileImageSrc]]];
  UIImage *img = [[UIImage alloc] initWithData:imgData ];

  [self changePhoto:img];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_nameLabel release];
    [_loginLabel release];
  [_photoImage release];
    [super dealloc];
}
@end
