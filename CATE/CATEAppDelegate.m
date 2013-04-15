//
//  CATEAppDelegate.m
//  CATE
//
//  Created by Tom Burnell on 11/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import "CATEAppDelegate.h"
#import "CATETerm.h"

@implementation CATEAppDelegate

@synthesize identity, userAtLogin, passwordAtLogin, cateVersion;


- (void)cache_term:(CATETerm *)term {
  // Saves the given term in the appropriate field
  
  NSString *period
    = [[term.title componentsSeparatedByString: @" "] objectAtIndex:0];
  
  NSLog(period);
  
  if ([period isEqualToString:@"Autumn"]) {
    self.autumn = term;
    
  } else if ([period isEqualToString:@"Christmas"]) {
    self.christmas = term;
    
  } else if ([period isEqualToString:@"Spring"]) {
    self.spring = term;
    
  } else if ([period isEqualToString:@"Easter"]) {
    self.easter = term;
    
  } else if ([period isEqualToString:@"Summer"]) {
    self.summer = term;
    
  } else if ([period isEqualToString:@"June-July"]) {
    self.june_july = term;
    
  } else if ([period isEqualToString:@"August-September"]) {
    self.august_september = term;
    
  }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
