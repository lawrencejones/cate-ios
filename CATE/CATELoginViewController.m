//
//  CATELoginViewController.m
//  CATE
//
//  Created by Tom Burnell on 11/04/2013.
//  ... AND Lawrence Jones. Pfft.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import "CATELoginViewController.h"
#import "CATEUtilities.h"
#import "SMXMLDocument.h"
#import "CATEDataExtractor.h"
#import "CATERecord.h"

@implementation CATELoginViewController

@synthesize userString = _userString;
@synthesize passwordString = _passwordString;
@synthesize keyboardToolbar, txtActiveField;
@synthesize fieldBg = _fieldBg, button = _button;
@synthesize main_data = _main_data, ex_data = _ex_data, grade_data = _grade_data,
          fullHtml = _fullHtml, user = _user, password = _password, data = _data;

#pragma mark- Initialisation

- (id)initWithNibName:(NSString *)nib_name_or_nil
               bundle:(NSBundle *)nib_bunble_or_nil {
  
  self = [super initWithNibName:nib_name_or_nil bundle:nib_bunble_or_nil];
  if (self) {
  
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _data = [CATESharedData instance];
  // Set initial fullHtml value
  self.fullHtml = [self getFile:@"extraction_page" ofType:@"html"];
  [self initialiseLoginButtonImages];
  [self initialiseAndConfigureBackgroundWebview];
  [self initialiseProgressBar];
  [self setTextFieldProperties];
  [self createLogo];
  [self createInputAccessoryView];
  [self initialAnimation];
}

- (void)initialiseAndConfigureBackgroundWebview {
  self.backgroundWeb = [[[UIWebView alloc] initWithFrame:CGRectZero] autorelease];
  [self.backgroundWeb setDelegate:self];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark- Setting UI Properties

-(void)initialiseProgressBar {
  [self.progressBar setOpaque:NO];
  [self.progressBar setBackgroundColor:[UIColor clearColor]];
  self.progressBar.alpha = 0;
  NSString *link = [[NSBundle mainBundle] pathForResource:@"loading_page" ofType:@"html"];
  NSURL *url = [NSURL fileURLWithPath:link];
  [self.progressBar loadRequest:[NSURLRequest requestWithURL:url]];
}

-(void)initialiseLoginButtonImages {
  self->loginDefault = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wideDarkLogin" ofType:@"png"]];
  self->loginAuth    = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wideDarkLoginAuth" ofType:@"png"]];
  self->loginLoading = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wideDarkLoginLoading" ofType:@"png"]];
  self->loginDone    = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wideDarkLoginDone" ofType:@"png"]];
}

- (void)setTextFieldProperties {
  [_user setBackgroundColor:[UIColor clearColor]];
  [_user setBorderStyle:UITextBorderStyleNone];
  [_user setDelegate:self];
  
  [_password setBackgroundColor:[UIColor clearColor]];
  [_password setBorderStyle:UITextBorderStyleNone];
  [_password setDelegate:self];

}

- (void)createLogo {
  NSString *path = [[NSBundle mainBundle] pathForResource:@"basicLogo" ofType:@"png"];
  UIImage *logoImg = [[UIImage alloc] initWithContentsOfFile:path];
  self.logo = [[UIImageView alloc] initWithImage:logoImg];
  self.logo.alpha = 0;
  self.logo.frame = CGRectMake(90, 200, 320, 200);
  self.logo.center = CGPointMake(160, 260);
  self.logo.contentMode = UIViewContentModeScaleAspectFit;
  [self.view addSubview:self.logo];
}

#pragma mark - Animation Methods

-(void)initialAnimation {
  [UIView animateWithDuration:0.3 delay:0.3
                      options:(UIViewAnimationCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                   animations:^{
                     [self.logo setAlpha:1];
                   }
                   completion:^(BOOL finished){
                     [self animateLogoSlide];
                     [self animateFieldFadeIn];
                   }];
}

-(void)animateLogoSlide {
  [UIView animateWithDuration:0.5 delay:0.1
                      options:(UIViewAnimationCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                   animations:^{
    self.logo.center = CGPointMake(160, 80);
  }completion:^(BOOL finished){
    //do next
  }];
}

-(void)animateFieldFadeIn {
  [UIView animateWithDuration:0.3 delay:0.6
                      options:(UIViewAnimationCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                   animations:^{
                     _fieldBg.alpha  = 1;
                     _user.alpha     = 1;
                     _password.alpha = 1;
                     _button.alpha   = 1;
                   } completion:nil];
}

#pragma mark - Login Button Status

-(void)resetButton {
  [_button setImage:self->loginDefault forState:UIControlStateNormal];
}

-(void)attemptAuth {
  [_button setImage:self->loginAuth forState:UIControlStateNormal];
}

-(void)startLoad {
  [_button setImage:self->loginLoading forState:UIControlStateNormal];
}

-(void)finishLoad {
  [_button setImage:self->loginDone forState:UIControlStateNormal];
}

#pragma mark- Text Entry Behaviour

-(void)createInputAccessoryView
{
  self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
  self.keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
  //self.keyboardToolbar.tintColor = [UIColor darkGrayColor];
  
  UIBarButtonItem* previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered target:self action:@selector(gotoPrevTextfield)];
  UIBarButtonItem* nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(gotoNextTextfield)];
  UIBarButtonItem* flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(touchUpMyBody:)];
  
  [self.keyboardToolbar setItems:[NSArray arrayWithObjects: previousButton, nextButton, flexSpace, doneButton, nil]];
  
  [_user setInputAccessoryView:self.keyboardToolbar];
  [_password setInputAccessoryView:self.keyboardToolbar];
}


-(void)gotoPrevTextfield
{
  if (self.txtActiveField == _user)
  {
    return;
  }
  else if (self.txtActiveField == _password)
  {
    [_user becomeFirstResponder];
  }
}

-(void)gotoNextTextfield
{
  if (self.txtActiveField == _user)
  {
    [_password becomeFirstResponder];
  }
  else if (self.txtActiveField == _password)
  {
    return;
  }
}

- (void) toggleLoginFieldsVisibility {
  
  if (self.button.alpha == 1) {
    // Everything is active, make it unactive
    
    _user.enabled = NO;
    _user.alpha = 0.5;
    
    _password.enabled = NO;
    _password.alpha = 0.5;
    
    [self.button setTitle:@"Logging in..." forState:UIControlStateNormal];
    self.button.enabled = NO;
    self.button.alpha = 0.8;
    
  } else {
    // Everything is unactive, make it active
    
    _user.enabled = YES;
    _user.alpha = 1;
    
    _password.text = @"";
    _password.enabled = YES;
    _password.alpha = 1;
    
    [self.button setTitle:@"Login" forState:UIControlStateNormal];
    self.button.enabled = YES;
    self.button.alpha = 1;
    
  }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  self.txtActiveField = textField;
}

- (IBAction)touchUpMyBody:(id)sender {
  [self.view endEditing:YES];
}

#pragma mark- CATe Connection

- (IBAction)loginAttempt:(id)sender {
  // Called when the login button is tapped
  [self attemptAuth];
  [self.progressBar stringByEvaluatingJavaScriptFromString:@"resetProgressBar(3);"];
  [UIWebView animateWithDuration:0.3 animations:^(void){
    self.progressBar.alpha = 1;
  }];
  
  self.userString = self.user.text;
  self.passwordString = self.password.text;
  
  _data.userAtLogin = self.userString;
  _data.passwordAtLogin = self.passwordString;
  
  [self toggleLoginFieldsVisibility];
  
  [self getAllCATEData];
}

- (void)authenticationFailed {
  [UIWebView animateWithDuration:0.1
                      animations:^(void){
    self.progressBar.alpha = 0;
  }];
  for (int i = 0; i < [self->connections count]; i++) {
    [[self->connections objectAtIndex:i] cancel];
  }
  [CATEUtilities showAlert:@"Error" message:@"Invalid credentials" delegate:nil cancel_bottom:@"OK"];
  [self toggleLoginFieldsVisibility];
  [self resetButton];
}

#pragma mark - Creating list of links

- (void)getAllCATEData {
  NSArray *links =
   [NSArray arrayWithObjects:@"https://cate.doc.ic.ac.uk/",
   [NSString stringWithFormat:@"https://cate.doc.ic.ac.uk/timetable.cgi?keyt=2012:4:c1:%@", _data.userAtLogin],
   [NSString stringWithFormat:@"https://cate.doc.ic.ac.uk/student.cgi?key=2012:c1:%@", _data.userAtLogin], nil];
  
  [self sendRequests:links];
}

#pragma mark - Web View Finished? Moving on...

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  // The WebView in LoadView is loaded more than once. We only want to
  // do something after it's finished loading for the final time, hence:
    
  if (!self->complete) {
    return;
  }
  
  if (webView == self.backgroundWeb) {
    NSLog(@"WebView loaded!");
  }
  
  NSString *xmlMainStr = [CATEDataExtractor get_main_xml:self.backgroundWeb];
  NSData *xmlMainData = [xmlMainStr dataUsingEncoding:NSUTF8StringEncoding];
  [_data setIdentity:[CATEIdentity identity_with_data:xmlMainData]];
  
  NSString *xmlTermStr = [CATEDataExtractor get_exercises_xml:self.backgroundWeb];
  NSData *xmlTermData = [xmlTermStr dataUsingEncoding:NSUTF8StringEncoding];
  CATETerm *term = [CATETerm term_with_data:xmlTermData];
  [_data cache_term:&*term];
  
  NSString *xmlGradesStr = [CATEDataExtractor get_grades_xml:self.backgroundWeb];
  NSData *xmlGradesData = [xmlGradesStr dataUsingEncoding:NSUTF8StringEncoding];
  CATERecord *record = [CATERecord record_with_data:xmlGradesData];
  _data.record = record;
  
  [self finishLoad];
  
  [self segueToDashboard];


}

-(void)segueToDashboard {
  //double delayInSeconds = 2.0;
  //dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  //dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [self performSegueWithIdentifier:@"segueToDashboard" sender:self];
  //});
}

#pragma mark - URL Requester

-(void) sendRequests: (NSArray *) strLinks {
  self->count = [strLinks count];
  self->connections = [[NSMutableArray alloc] initWithCapacity:self->count];
  for (int i = 0; i < [strLinks count]; i++) {
    NSMutableURLRequest *request =
    [NSMutableURLRequest
     requestWithURL:[NSURL URLWithString:[strLinks objectAtIndex:i]]];
    
    [request addValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
    NSURLConnection *c =[[NSURLConnection alloc] initWithRequest:request delegate:self
                            startImmediately:YES];
    [self->connections insertObject:c atIndex:i];
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
       initWithUser:_data.userAtLogin
       password:_data.passwordAtLogin
       persistence:NSURLCredentialPersistenceForSession];
    
    [[challenge sender] useCredential:creden
           forAuthenticationChallenge:challenge];
    
  } else {
    // Authentication failure (This is a precautionary measure. Credentials
    // are in fact verified before this LoadView is even initiated.)
    NSLog(@"Authentication failed.");
    [self authenticationFailed];
  }
  
}


- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data {
  
  [self startLoad];
  
  NSString *path = [[[connection originalRequest] URL] relativePath];
  
  if ([path isEqualToString:@"/"]) {
    _main_data  = [[NSString alloc] initWithData:data
                                            encoding:NSUTF8StringEncoding];
    
  } else if ([path isEqualToString:@"/timetable.cgi"]) {
    _ex_data    = [[NSString alloc] initWithData:data
                                            encoding:NSUTF8StringEncoding];
    
  } else if ([path isEqualToString:@"/student.cgi"]) {
    _grade_data = [[NSString alloc] initWithData:data
                                            encoding:NSUTF8StringEncoding];
  }
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  
  NSLog(@"Finished connection...");
  [self injectCateHtml:connection];
  [self.progressBar stringByEvaluatingJavaScriptFromString:
   @"advanceProgress();"];
  count--;
  if (count == 0) {
    self->complete = true;
    [self.backgroundWeb loadHTMLString:self.fullHtml baseURL:NULL];
  }
}


#pragma mark - Populate Html

- (void)injectCateHtml:(NSURLConnection *)connection {
  
  NSString *data, *target, *start = @"<body bgcolor=\"#e0f9f9\">";
  NSString *path = [[[connection originalRequest] URL] relativePath];
  
  if ([path isEqualToString:@"/"]) {
    data = _main_data;
    target = @"#{MAIN_PAGE_BODY_STRING}";
    
  } else if ([path isEqualToString:@"/timetable.cgi"]) {
    data = _ex_data; start = @"<body>";
    target = @"#{EXERCISE_PAGE_BODY_STRING}";
    
  } else /*if ([path isEqualToString:@"/student.cgi"]) */ {
    data = _grade_data;
    target = @"#{GRADES_PAGE_BODY_STRING}";
  }
  
  NSArray *tmp = [data componentsSeparatedByString: start];
  NSString *body = [tmp objectAtIndex:1];
  body = [[body componentsSeparatedByString:@"</body>"] objectAtIndex:0];
  
  self.fullHtml = [self.fullHtml
                    stringByReplacingOccurrencesOfString:target
                    withString:body];
}

#pragma mark - Utilities

-(NSString*)replace:(NSString *)source p2:(NSString *)target
                 p3:(NSString *)goal {
  return [source stringByReplacingOccurrencesOfString:target withString:goal];
}

-(NSString*)getFile:(NSString *)res ofType:(NSString *)file_type {
    
  NSString *filePath
  = [[NSBundle mainBundle] pathForResource:res ofType:file_type];
  NSData *fileData
  = [NSData dataWithContentsOfFile:filePath];
  return [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
  
}

#pragma mark- Release iVars

- (void)dealloc {
  [_user release];
  [_password release];
  [_user release];
  [_password release];
  [_button release];
  [_main_data release];
  [_ex_data release];
  [_grade_data release];
  [_data release];
  [keyboardToolbar release];
  [txtActiveField release]; 
  [super dealloc];
}
@end
