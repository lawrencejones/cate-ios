//
//  CATEFirstViewController.h
//  CATE
//
//  Created by Tom Burnell on 11/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CATESharedData.h"

@interface CATEFirstViewController : UIViewController
{
  CATESharedData *data;
}

@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *loginLabel;
@property (retain, nonatomic) IBOutlet UIImageView *photoImage;
@property (retain, nonatomic) CATESharedData *data;

- (void)changeNameLabel: (NSString *)name;
- (void)changeLoginLabel: (NSString *)login;
- (void)changePhoto: (UIImage *)photo;

@end
