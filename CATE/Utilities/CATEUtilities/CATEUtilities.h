//
//  CATEUtilities.h
//  CATE
//
//  Created by Tom Burnell on 12/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CATESharedData.h"

@interface CATEUtilities : NSObject;

+ (void) setCateVersion:(NSString *)version;

+ (void) showAlert:(NSString *)title message:(NSString *)message
          delegate:(NSObject *)delegate cancel_bottom:(NSString *)cancel_button;

+ (void) initializeConnection:(NSString *)url delegate:(NSObject*)delegate;

@end