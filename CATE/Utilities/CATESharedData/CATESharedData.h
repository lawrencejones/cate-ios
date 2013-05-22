//
//  CATESharedData.h
//  CATE
//
//  Created by Lawrence Jones on 20/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CATEIdentity.h"
#import "CATETerm.h"
#import "CATERecord.h"

@interface CATESharedData : NSObject

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


+ (CATESharedData*) instance;
- (void) cache_term:(CATETerm *)term;

@end
