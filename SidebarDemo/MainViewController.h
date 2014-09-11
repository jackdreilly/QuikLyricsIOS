//
//  ViewController.h
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "MLPAutoCompleteTextFieldDelegate.h"

@class SuggestionsDataSource;
@class MLPAutoCompleteTextField;
@interface MainViewController : UIViewController <UITextFieldDelegate, MLPAutoCompleteTextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet SuggestionsDataSource *autocompleteDataSource;
@property (weak) IBOutlet MLPAutoCompleteTextField *autocompleteTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *typeSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *dimSwitch;
@property (weak) IBOutlet UIWebView* webView;

- (void)getLyrics: (NSString*) songTitle;

@end
