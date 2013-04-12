//
//  CATEIdentity.m
//  CATE
//
//  Created by Tom Burnell on 11/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import "CATEIdentity.h"
#import "SMXMLDocument.h"

@implementation CATEIdentity

@synthesize profileImageSrc, firstName, lastName, fullName, login, category,
            candidateNumber, cid, personalTutor;

- (id) init_with_data:(NSData *)xml {
  // PRE:  The xml in the given NSData is well-formed and contains all the
  //       necessary information.
  // POST: Returns an instance of CATEIdentity, holding the extracted values
  
  self = [super init];
  
  if (self) {
    // parse given xml here, and set field values
    
    NSError *err = NULL;
    SMXMLDocument *document = [SMXMLDocument documentWithData:xml error:&err];
    
    NSString *firstSpace
      = [[document.root valueWithPath:@"first_name"]
         stringByAppendingString:@" "];
    NSString *full
      = [firstSpace stringByAppendingString:
         [document.root valueWithPath:@"last_name"]];
    
    profileImageSrc = [document.root valueWithPath:@"profile_image_src"];
    firstName = [document.root valueWithPath:@"first_name"];
    lastName = [document.root valueWithPath:@"last_name"];
    fullName = full;
    login = [document.root valueWithPath:@"login"];
    category = [document.root valueWithPath:@"category"];
    candidateNumber = [document.root valueWithPath:@"candidate_number"];
    cid = [document.root valueWithPath:@"cid"];
    personalTutor = [document.root valueWithPath:@"personal_tutor"];
  }
  
  return self;
}

+ (id) identity_with_data:(NSData *)xml {
  CATEIdentity *identity = [[[self alloc] init_with_data:xml] autorelease];
  return identity;
}

@end