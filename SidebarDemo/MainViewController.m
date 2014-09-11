//
//  ViewController.m
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "MainViewController.h"
#import "MLPAutoCompleteTextField.h"
#import "SuggestionsDataSource.h"
#import "AFNetworking.h"
#import "CJSONDeserializer.h"


@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _sidebarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
    
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowWithNotification:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideWithNotification:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.dimSwitch addTarget:self
                        action:@selector(typeDidChange:)
              forControlEvents:UIControlEventValueChanged];

    [self.autocompleteTextField setBorderStyle:UITextBorderStyleRoundedRect];
    
    
    [self.autocompleteTextField setShowAutoCompleteTableWhenEditingBegins:YES];
     self.autocompleteTextField.applyBoldEffectToAutoCompleteSuggestions = NO;

}

- (void)typeDidChange:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
    } else {
        NSLog(@"Off");
    }
    [[UIApplication sharedApplication] setIdleTimerDisabled:[sender isOn]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MLPAutoCompleteTextField Delegate


- (BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
          shouldConfigureCell:(UITableViewCell *)cell
       withAutoCompleteString:(NSString *)autocompleteString
         withAttributedString:(NSAttributedString *)boldedString
        forAutoCompleteObject:(id<MLPAutoCompletionObject>)autocompleteObject
            forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return YES;
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
  didSelectAutoCompleteString:(NSString *)selectedString
       withAutoCompleteObject:(id<MLPAutoCompletionObject>)selectedObject
            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self getLyrics:selectedString];
}

- (void)getLyrics: (NSString*) songTitle {
    if ([songTitle length] < 3) {
        return;
    }
    NSString* contentType;
    if ([self.typeSwitch selectedSegmentIndex] == 0) {
        contentType = @"lyrics";
    } else {
        contentType = @"chords";
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"songTitle": songTitle,@"contenttype": contentType, @"country": @"ios"};
    [manager GET:@"http://quiklyrics.appspot.com/getlyrics" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dictionary = responseObject;
        NSMutableString* html = [[NSMutableString alloc] initWithString:@"<meta name=\"viewport\" content=\"width=320\" /><div style=\"overflow:hidden; padding-bottom:100px;\"><h1>"];
        [html appendString:[dictionary objectForKey:@"title"]];
        [html appendString:@"</h1><br />"];
        [html appendString:[dictionary objectForKey: @"post"]];
        [html appendString:@"</div>"];
        [self.webView loadHTMLString:[NSString stringWithString:html] baseURL:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}



#pragma mark - Other listener

- (void)keyboardDidShowWithNotification:(NSNotification *)aNotification
{

}


- (void)keyboardDidHideWithNotification:(NSNotification *)aNotification
{
    [self.autocompleteTextField setAutoCompleteTableViewHidden:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self getLyrics:[textField text]];
    return YES;
}



@end
