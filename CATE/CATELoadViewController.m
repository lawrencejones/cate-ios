//
//  CATELoadViewController.m
//  CATE
//
//  Created by Tom Burnell on 11/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import "CATELoadViewController.h"

@interface CATELoadViewController () {
  NSString *main_data;
  NSString *ex_data;
  NSString *grade_data;
  NSString *full_html;
  int count;
}

@property(retain,nonatomic) NSString *main_data;
@property(retain,nonatomic) NSString *ex_data;
@property(retain,nonatomic) NSString *grade_data;
@property(retain,nonatomic) NSString *full_html;

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
  
  /*
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
   */

}

#pragma mark - URL Requester

-(NSArray *) getRequestArrayForStringLinks: (NSArray *) str_links{
  NSMutableArray *requests = [NSMutableArray arrayWithCapacity:[str_links count]];
  for (int i = 0; i < [str_links count]; i++) {
    NSMutableURLRequest *request =
      [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[str_links objectAtIndex:i]]];
    [request addValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
    [requests insertObject:request atIndex:i];
  }
  NSLog(@"Processed requests.");
  return requests;
}

-(void) getHtmlStringForRequests: (NSArray *) requestsArray{
  count = [requestsArray count];
  for (NSURLRequest *request in requestsArray) {
    [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
  }
}


- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
  if([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPBasic])
  {
    return YES;
  } else return NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
  NSURLCredential *creden = [[NSURLCredential alloc] initWithUser:@"lmj112" password:@"738dba965D" persistence:NSURLCredentialPersistenceForSession];
  [[challenge sender] useCredential:creden forAuthenticationChallenge:challenge];

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  
  NSString *path = [[[connection originalRequest] URL] relativePath];
  NSLog(@"More data!");
  if ([path isEqualToString:@"/"]) {
    main_data = [[NSString alloc] initWithData:data
                                      encoding:NSUTF8StringEncoding];
    NSLog(@"Main data updated!");
  } else if ([path rangeOfString:@"timetable"].location != NSNotFound) {
    ex_data = [[NSString alloc] initWithData:data
                                    encoding:NSUTF8StringEncoding];
  } else if ([path rangeOfString:@"student"].location != NSNotFound) {
    grade_data = [[NSString alloc] initWithData:data
                                       encoding:NSUTF8StringEncoding];
  }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  [self inject_cate_html:connection];
  count--;
  if (count == 0) {
    [self.loadingWeb loadHTMLString:full_html baseURL:NULL];
  }
}

#pragma mark - Populate Html


- (void)makeLoadingViewLoad {
  
  [self initialWebViewSetup];
  
}

-(NSString*)getFileContent:(NSString *) res :
                           (NSString *) file_type {
  NSString *filePath
    = [[NSBundle mainBundle] pathForResource:res ofType:file_type];
  NSData *fileData
    = [NSData dataWithContentsOfFile:filePath];
  return [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
}

-(NSString*)replace:(NSString *) source : (NSString *) target : (NSString *) goal {
  return [source stringByReplacingOccurrencesOfString:target withString:goal];
}

- (void)initialWebViewSetup {
  
  NSString *htmlString       = [ self getFileContent:@"loading_page"     :@"html" ];
  NSString *bootstrap_js     = [ self getFileContent:@"bootstrap.min"    :@"js"   ];
  NSString *bootstrap_css    = [ self getFileContent:@"bootstrap.min"    :@"css"  ];
  NSString *extraction_tools = [ self getFileContent:@"extraction_tools" :@"js"   ];
  NSString *loading_css      = [ self getFileContent:@"loading_page"     :@"css"  ];
  
  htmlString = [ self replace:htmlString:@"#{BOOTSTRAP_JS_STRING}"        :bootstrap_js     ];
  htmlString = [ self replace:htmlString:@"#{EXTRACTION_TOOLS_JS_STRING}" :extraction_tools ];
  htmlString = [ self replace:htmlString:@"#{BOOTSTRAP_CSS_STRING}"       :bootstrap_css    ];
  htmlString = [ self replace:htmlString:@"#{LOADING_PAGE_CSS_STRING}"    :loading_css      ];
  
  // Copy the htmlString once initialised into the instance property
  full_html = htmlString;
  
  // (2) Tell the web view to load the HTML in the string
  [self.loadingWeb
         loadHTMLString:htmlString
                baseURL:[NSURL
        fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
  
  NSArray *requests =
    [self getRequestArrayForStringLinks:
     [NSArray arrayWithObjects:@"https://cate.doc.ic.ac.uk/",
                               @"https://cate.doc.ic.ac.uk/timetable.cgi?keyt=2012:3:c1:lmj112",
                               @"https://cate.doc.ic.ac.uk/student.cgi?key=2012:c1:lmj112", nil]];
  [self getHtmlStringForRequests:requests];
}

- (void)inject_cate_html:(NSURLConnection *)connection {
  
  NSString *data, *target, *start = @"<body bgcolor=\"#e0f9f9\">";
  NSString *path = [[[connection originalRequest] URL] relativePath];
  
  if ([path isEqualToString:@"/"])
  {
    data = main_data;
    target = @"#{MAIN_PAGE_BODY_STRING}";
  }
  else if ([path isEqualToString:@"timetable?"])
  {
    data = ex_data; start = @"<body>";
    target = @"#{EXERCISE_PAGE_BODY_STRING}";
  }
  else if ([path isEqualToString:@"student?"])
  {
    data = grade_data;
    target = @"#{GRADES_PAGE_BODY_STRING}";
  }
  
  NSArray *body = [data componentsSeparatedByString: start];
  body = [[[body objectAtIndex:1] componentsSeparatedByString:@"</body>"] objectAtIndex:0];
  
  full_html = [ self replace:full_html:target:body];
  
}

@end
