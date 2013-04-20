//
//  CATEFirstViewController.m
//  CATE
//
//  Created by Tom Burnell on 11/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import "CATEFirstViewController.h"

@implementation CATEFirstViewController

@synthesize data = _data;

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


- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  _data = [CATESharedData instance];
  
  CATEIdentity *identity = _data.identity;
  
  [self changeNameLabel:identity.fullName];
  [self changeLoginLabel:identity.login];
  
  NSString *imgUrl
  = [NSString stringWithFormat:@"https://cate.doc.ic.ac.uk/%@",
     identity.profileImageSrc];
  
  NSData *imgData
    = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
  
  UIImage *img = [[UIImage alloc] initWithData:imgData ];

  [self changePhoto:img];
  [img release];
  
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (void)dealloc {
  [_nameLabel release];
  [_loginLabel release];
  [_photoImage release];
  [_data release];
  [super dealloc];
}

@end
