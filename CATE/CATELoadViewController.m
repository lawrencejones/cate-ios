//
//  CATELoadViewController.m
//  CATE
//
//  Created by Tom Burnell on 11/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import "CATELoadViewController.h"

@interface CATELoadViewController ()

@end

@implementation CATELoadViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  // This method is called after the entire view is loaded
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
  
  // Calls helper method, makeLoadingViewLoad
  [self makeLoadingViewLoad];
  
  // Disables the web view from being scrollable
  self.loadingWeb.scrollView.scrollEnabled = NO;
  self.loadingWeb.scrollView.bounces = NO; // (old) dot notation
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  
  // Fetches the myScript.js file, and ultimately pulls its contents into
  // a string, jsString.
  NSString *filePath
    = [[NSBundle mainBundle] pathForResource:@"myScript" ofType:@"js"];
  NSData *fileData
    = [NSData dataWithContentsOfFile:filePath];
  NSString *jsString
    = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
  
  // Injects the JS in jsString into the given web view. A string is returned,
  // containing the result of running the script, but at this stage we don't
  // require this so won't save it.
  [webView stringByEvaluatingJavaScriptFromString:jsString];
  
  // Calls helper functions in the script just injected, and stores their
  // results in string variables.
  // Ultimately, the values returned will be xml.
  NSString *dashString
    = [webView stringByEvaluatingJavaScriptFromString:@"dealWithDashboard()"];
  NSString *exercisesString
    = [webView stringByEvaluatingJavaScriptFromString:@"dealWithExercises()"];
  NSString *gradesString
    = [webView stringByEvaluatingJavaScriptFromString:@"dealWithGrades()"];
   
  NSString *delayTry
  = [webView stringByEvaluatingJavaScriptFromString:@"tryDelay()"];
  
  // iOS will wait for the above JS to execute (delayTry), before continuing...
  // Perfect!
  if ([dashString isEqualToString:@"error"]) {
    // Error occurred loading dashboard: don't continue
    
    UIAlertView *alert
    = [[UIAlertView alloc] initWithTitle:@"Error"
                                 message:@"An error occurred loading the dashboard"
                                delegate:nil
                       cancelButtonTitle:@"OK"
                       otherButtonTitles:nil];
    [alert show];
    
  } else {
    
    if ([exercisesString isEqualToString:@"error"]) {
      // Error occurred loading exercises: don't continue
      
      UIAlertView *alert
      = [[UIAlertView alloc] initWithTitle:@"Error"
                                   message:@"An error occurred loading the exercises"
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
      [alert show];
      
    } else {
      
      if ([gradesString isEqualToString:@"error"]) {
        // Error occurred loading grades: don't continue
        
        UIAlertView *alert
        = [[UIAlertView alloc] initWithTitle:@"Error"
                                     message:@"An error occurred loading the grades"
                                    delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil];
        [alert show];
        
      } else {
        
        // Populate views!
        
        [self performSegueWithIdentifier:@"LoadMainView" sender:self];
        
      }
      
    }
    
  }

}

- (void)makeLoadingViewLoad {
  // (1) Pull the HTML in loading.html into htmlString
  NSString *filePath
    = [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"html"];
  NSData *fileData
    = [NSData dataWithContentsOfFile:filePath];
  NSString *htmlString
    = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
  
  // (2) Tell the web view to load the HTML in the string
  [self.loadingWeb
    loadHTMLString:htmlString
    baseURL:[NSURL
    fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

@end
