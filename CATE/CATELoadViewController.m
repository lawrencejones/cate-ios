//
//  CATELoadViewController.m
//  CATE
//
//  Created by Tom Burnell on 11/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import "CATELoadViewController.h"
#import "SMXMLDocument.h"
#import "CATEDataExtractor.h"
#import "CATERecord.h"

@implementation CATELoadViewController

@synthesize main_data, ex_data, grade_data, full_html;

- (id)initWithNibName:(NSString *)nib_name_or_nil
               bundle:(NSBundle *)nib_bundle_or_nil {
  
  self = [super initWithNibName:nib_name_or_nil bundle:nib_bundle_or_nil];
  if (self) {
    // Custom initialisation
  }
  return self;
}

#pragma mark - Initial Methods

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  // Set appDelegate iVar
  appDelegate = [[UIApplication sharedApplication] delegate];

  // Set initial full_html value
  self.full_html = [self getFile:@"extraction_page" ofType:@"html"];
  // Setup both webviews
  [self loadingWebViewSetup];
  [self backgroundWebViewSetup];
  
  // Get the CATEData
  [self getAllCATEData];

}

- (void)loadingWebViewSetup {
  // Disables the web view from being scrollable
  self.loadingWeb.scrollView.scrollEnabled = NO;
  self.loadingWeb.scrollView.bounces = NO;
  [self.loadingWeb setDelegate:self];
  NSString *filePath
  = [[NSBundle mainBundle] pathForResource:@"loading_page" ofType:@"html"];
  NSURL *url = [NSURL fileURLWithPath:filePath];
  [self.loadingWeb loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)backgroundWebViewSetup {
  self.backgroundWeb = [[[UIWebView alloc] initWithFrame:CGRectZero] autorelease];
  [self.backgroundWeb setDelegate:self];
  [self.backgroundWeb loadHTMLString:self.full_html baseURL:NULL];
}

- (void)getAllCATEData {
  NSArray *links =
    [NSArray arrayWithObjects:@"https://cate.doc.ic.ac.uk/",
    [NSString stringWithFormat:@"https://cate.doc.ic.ac.uk/timetable.cgi?keyt=2012:4:c1:%@", appDelegate.userAtLogin],
    [NSString stringWithFormat:@"https://cate.doc.ic.ac.uk/student.cgi?key=2012:c1:%@", appDelegate.userAtLogin], nil];
  
  [self sendRequests:links];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  // The WebView in LoadView is loaded more than once. We only want to
  // do something after it's finished loading for the final time, hence:
    
  if (!self->complete) {
    return;
  }
  
  if (webView == self.backgroundWeb) {
    NSLog(@"Done!");
  }
  
  NSString *xmlMainStr = [CATEDataExtractor get_main_xml:self.backgroundWeb];
  NSData *xmlMainData = [xmlMainStr dataUsingEncoding:NSUTF8StringEncoding];
  CATEIdentity *identity = [CATEIdentity identity_with_data:xmlMainData];
  appDelegate.identity = identity;
  
  NSString *xmlTermStr = [CATEDataExtractor get_exercises_xml:self.backgroundWeb];
  NSData *xmlTermData = [xmlTermStr dataUsingEncoding:NSUTF8StringEncoding];
  CATETerm *term = [CATETerm term_with_data:xmlTermData];
  [appDelegate cache_term:&*term];
  
  NSString *xmlGradesStr = [CATEDataExtractor get_grades_xml:self.backgroundWeb];
  NSData *xmlGradesData = [xmlGradesStr dataUsingEncoding:NSUTF8StringEncoding];
  CATERecord *record = [CATERecord record_with_data:xmlGradesData];
  appDelegate.record = record;
  
  [self performSegueWithIdentifier:@"LoadMainView" sender:self];
}


#pragma mark - URL Requester

-(void) sendRequests: (NSArray *) strLinks {
  self->count = [strLinks count];
  for (int i = 0; i < [strLinks count]; i++) {
    NSMutableURLRequest *request =
      [NSMutableURLRequest
          requestWithURL:[NSURL URLWithString:[strLinks objectAtIndex:i]]];
    
    [request addValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
    [[NSURLConnection alloc] initWithRequest:request delegate:self
                            startImmediately:YES];
  }
}


- (BOOL)connection:(NSURLConnection *)connection
        canAuthenticateAgainstProtectionSpace:
            (NSURLProtectionSpace *)protectionSpace {
  
  if([protectionSpace.authenticationMethod
      isEqualToString:NSURLAuthenticationMethodHTTPBasic]) {
    return YES;
  } else return NO;
}


- (void)connection:(NSURLConnection *)connection
        didReceiveAuthenticationChallenge:
            (NSURLAuthenticationChallenge *)challenge {
  
  if ([challenge previousFailureCount] == 0) {
    NSURLCredential *creden
      = [[NSURLCredential alloc]
            initWithUser:appDelegate.userAtLogin
                password:appDelegate.passwordAtLogin
             persistence:NSURLCredentialPersistenceForSession];
    
    [[challenge sender] useCredential:creden
           forAuthenticationChallenge:challenge];
    
  } else {
    // Authentication failure (This is a precautionary measure. Credentials
    // are in fact verified before this LoadView is even initiated.)
    [self performSegueWithIdentifier:@"LoadingToLogin" sender:self];
  }

}


- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data {
  
  NSString *path = [[[connection originalRequest] URL] relativePath];

  if ([path isEqualToString:@"/"]) {
    self.main_data  = [[NSString alloc] initWithData:data
                                            encoding:NSUTF8StringEncoding];
    
  } else if ([path isEqualToString:@"/timetable.cgi"]) {
    self.ex_data    = [[NSString alloc] initWithData:data
                                            encoding:NSUTF8StringEncoding];
  
  } else if ([path isEqualToString:@"/student.cgi"]) {
    self.grade_data = [[NSString alloc] initWithData:data
                                            encoding:NSUTF8StringEncoding];
  }
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  
  NSLog(@"PING!");
  
  [self inject_cate_html:connection];
  [self.loadingWeb stringByEvaluatingJavaScriptFromString:
                    @"$('body').trigger('click');"];
  count--;
  if (count == 0) {
    self->complete = true;
    [self.backgroundWeb loadHTMLString:self.full_html baseURL:NULL];
  }
}


#pragma mark - Populate Html

-(NSString*)replace:(NSString *)source p2:(NSString *)target
                 p3:(NSString *)goal {
  return [source stringByReplacingOccurrencesOfString:target withString:goal];
}

- (void)inject_cate_html:(NSURLConnection *)connection {
    
  NSString *data, *target, *start = @"<body bgcolor=\"#e0f9f9\">";
  NSString *path = [[[connection originalRequest] URL] relativePath];
  
  if ([path isEqualToString:@"/"]) {
    data = self.main_data;
    target = @"#{MAIN_PAGE_BODY_STRING}";
    
  } else if ([path isEqualToString:@"/timetable.cgi"]) {
    data = self.ex_data; start = @"<body>";
    target = @"#{EXERCISE_PAGE_BODY_STRING}";
    
  } else /*if ([path isEqualToString:@"/student.cgi"]) */ {
    data = self.grade_data;
    target = @"#{GRADES_PAGE_BODY_STRING}";
  }
    
  NSArray *tmp = [data componentsSeparatedByString: start];
  NSString *body = [tmp objectAtIndex:1];
  body = [[body componentsSeparatedByString:@"</body>"] objectAtIndex:0];
  
  self.full_html = [self.full_html
                    stringByReplacingOccurrencesOfString:target
                                              withString:body];
}

-(NSString*)getFile:(NSString *)res ofType:(NSString *)file_type {
  
  NSString *filePath
  = [[NSBundle mainBundle] pathForResource:res ofType:file_type];
  NSData *fileData
  = [NSData dataWithContentsOfFile:filePath];
  return [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
