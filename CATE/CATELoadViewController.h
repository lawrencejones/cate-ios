//
//  CATELoadViewController.h
//  CATE
//
//  Created by Tom Burnell on 11/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CATELoadViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *loadingWeb;

-(NSString*)getFileContent:(NSString *) res :(NSString *) file_type;


@end
