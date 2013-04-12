//
//  CATELoadViewController.m
//  CATE
//
//  Created by Tom Burnell on 11/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import "CATELoadViewController.h"
#import "SMXMLDocument.h"

@implementation CATELoadViewController

@synthesize main_data, ex_data, grade_data, full_html;

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
  
  // Create appDelegate for sharing data between views
  appDelegate = [[UIApplication sharedApplication] delegate];
  
  // Calls helper method, makeLoadingViewLoad
  self.full_html = [self initialWebViewSetup];
  
  NSArray *requests =
  [self getRequestArrayForStringLinks:
   [NSArray arrayWithObjects:@"https://cate.doc.ic.ac.uk/",
    @"https://cate.doc.ic.ac.uk/timetable.cgi?keyt=2012:3:c1:lmj112",
    @"https://cate.doc.ic.ac.uk/student.cgi?key=2012:c1:lmj112", nil]];
  
  [self getHtmlStringForRequests:requests];
  
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
  
  if (!self->complete) {
    return;
  }
  
  

  NSString *result = [webView stringByEvaluatingJavaScriptFromString:@"process_exercise_xml();"];
  NSLog(result);

  
//  [self performSegueWithIdentifier:@"LoadMainView" sender:self];
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

  if ([path isEqualToString:@"/"])
  {
    self.main_data  = [[NSString alloc] initWithData:data
                                    encoding:NSUTF8StringEncoding];
  }
  else if ([path isEqualToString:@"/timetable.cgi"])
  {
    self.ex_data    = [[NSString alloc] initWithData:data
                                    encoding:NSUTF8StringEncoding];
  }
  else if ([path isEqualToString:@"/student.cgi"])
  {
    self.grade_data = [[NSString alloc] initWithData:data
                                    encoding:NSUTF8StringEncoding];
  }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  [self inject_cate_html:connection];
  [self.loadingWeb stringByEvaluatingJavaScriptFromString:
   @"$('body').trigger('click');"];
  count--;
  if (count == 0) {
    self->complete = true;
    self.full_html = [ self replace:self.full_html p2:@"id=\"progress\" style=\"width : 0%;"
                              p3:@"id=\"progress\" style=\"width : 100%;"];
    [self.loadingWeb loadHTMLString:self.full_html baseURL:NULL];
  }
}

#pragma mark - Populate Html


-(NSString*)getFileContent:(NSString *)res :(NSString *)file_type {
  NSString *filePath
    = [[NSBundle mainBundle] pathForResource:res ofType:file_type];
  NSData *fileData
    = [NSData dataWithContentsOfFile:filePath];
  return [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
}

-(NSString*)replace:(NSString *)source p2:(NSString *)target p3:(NSString *)goal {
  return [source stringByReplacingOccurrencesOfString:target withString:goal];
}

- (NSString *)initialWebViewSetup {
  
  NSString *htmlString       = [ self getFileContent:@"loading_page"     :@"html" ];
  NSString *jquery_js        = [ self getFileContent:@"jquery-1.9.1.min" :@"js"   ];
  NSString *bootstrap_js     = [ self getFileContent:@"bootstrap.min"    :@"js"   ];
  NSString *bootstrap_css    = [ self getFileContent:@"bootstrap.min"    :@"css"  ];
  NSString *extraction_tools = [ self getFileContent:@"extraction_tools" :@"js"   ];
  NSString *loading_css      = [ self getFileContent:@"loading_page"     :@"css"  ];
  
  htmlString = [ self replace:htmlString p2:@"#{JQUERY_JS_STRING}"           p3:jquery_js        ];
  htmlString = [ self replace:htmlString p2:@"#{BOOTSTRAP_JS_STRING}"        p3:bootstrap_js     ];
  htmlString = [ self replace:htmlString p2:@"#{EXTRACTION_TOOLS_JS_STRING}" p3:extraction_tools ];
  htmlString = [ self replace:htmlString p2:@"#{BOOTSTRAP_CSS_STRING}"       p3:bootstrap_css    ];
  htmlString = [ self replace:htmlString p2:@"#{LOADING_PAGE_CSS_STRING}"    p3:loading_css      ];
  
  // (2) Tell the web view to load the HTML in the string
  [self.loadingWeb
         loadHTMLString:htmlString
                baseURL:[NSURL
        fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
  
  return htmlString;
  
}

- (void)inject_cate_html:(NSURLConnection *)connection {
  
  
  NSString *data, *target, *start = @"<body bgcolor=\"#e0f9f9\">";
  NSString *path = [[[connection originalRequest] URL] relativePath];
  
  if ([path isEqualToString:@"/"])
  {
    data = self.main_data;
    target = @"#{MAIN_PAGE_BODY_STRING}";
  }
  else if ([path isEqualToString:@"/timetable.cgi"])
  {
    data = self.ex_data; start = @"<body>";
    target = @"#{EXERCISE_PAGE_BODY_STRING}";
  }
  else //if ([path isEqualToString:@"/student.cgi"])
  {
    data = self.grade_data;
    target = @"#{GRADES_PAGE_BODY_STRING}";
  }
    
  NSArray *tmp = [data componentsSeparatedByString: start];
  NSString *body = [tmp objectAtIndex:1];
  tmp = [body componentsSeparatedByString:@"</body>"];
  body = [tmp objectAtIndex:0];
  
  self.full_html = [self.full_html stringByReplacingOccurrencesOfString:target withString:body];
  
}

@end
