//
//  CATEIdentity.h
//  CATE
//
//  Created by Tom Burnell on 11/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CATEIdentity : NSObject {
  NSString *profileImageSrc;
  NSString *firstName;
  NSString *lastName;
  NSString *login;
  NSString *category;
  NSString *candidateNumber;
  NSString *cid;
  NSString *personalTutor;
}

@property (retain) NSString *profileImageSrc;
@property (retain) NSString *firstName;
@property (retain) NSString *lastName;
@property (retain) NSString *login;
@property (retain) NSString *category;
@property (retain) NSString *candidateNumber;
@property (retain) NSString *cid;
@property (retain) NSString *personalTutor;

- (id) init_with_data:(NSData *)xml;
+ (id) identity_with_data:(NSData *)xml;

- (NSString *) fullName;

@end
