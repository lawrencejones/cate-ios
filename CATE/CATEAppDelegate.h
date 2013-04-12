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

@interface CATEAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (retain, nonatomic) CATEIdentity *identity;
@property (retain, nonatomic) CATETerm *termAutumn;
@property (retain, nonatomic) CATETerm *termAutumnBreak;
@property (retain, nonatomic) CATETerm *termSpring;
@property (retain, nonatomic) CATETerm *termSpringBreak;
@property (retain, nonatomic) CATETerm *termSummer;
@property (retain, nonatomic) CATETerm *termSummerBreak;

- (void) cache_term:(CATETerm *)term;

@end
