//
//  CATEAppDelegate.h
//  CATE
//
//  Created by Tom Burnell on 11/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CATEIdentity.h"
#import "CATETerm.h"
#import "CATERecord.h"

@interface CATEAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (retain, nonatomic) CATEIdentity *identity;
@property (retain, nonatomic) CATETerm *autumn;
@property (retain, nonatomic) CATETerm *spring;
@property (retain, nonatomic) CATETerm *summer;
@property (retain, nonatomic) CATETerm *christmas;
@property (retain, nonatomic) CATETerm *easter;
@property (retain, nonatomic) CATETerm *june_july;
@property (retain, nonatomic) CATETerm *august_september;
@property (retain, nonatomic) CATERecord *record;


@property (retain, nonatomic) NSString *userAtLogin;
@property (retain, nonatomic) NSString *passwordAtLogin;

@property (retain, nonatomic) NSString *cateVersion;



- (void) cache_term:(CATETerm *)term;

@end
