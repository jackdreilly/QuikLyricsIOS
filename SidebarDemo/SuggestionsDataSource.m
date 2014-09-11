//
//  DEMODataSource.m
//  MLPAutoCompleteDemo
//
//  Created by Eddy Borja on 5/28/14.
//  Copyright (c) 2014 Mainloop. All rights reserved.
//

#import "SuggestionsDataSource.h"
#import "AFNetworking.h"
#import "MLPAutoCompleteTextField.h"

@interface SuggestionsDataSource ()

@end


@implementation SuggestionsDataSource


#pragma mark - MLPAutoCompleteTextField DataSource

//example of asynchronous fetch:
- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
            completionHandler:(void (^)(NSArray *))handler
{
    if ([string length] < 5) {
        return;
    }
    NSString* contentType;
    if (YES) {
        contentType = @"lyrics";
    } else {
        contentType = @"chords";
    }
        NSDictionary *parameters = @{@"query": string,@"contenttype": contentType};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

        [manager GET:@"http://quiklyrics.appspot.com/suggest" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSDictionary *dictionary = responseObject;
            handler([dictionary objectForKey: @"results"]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
}




@end
