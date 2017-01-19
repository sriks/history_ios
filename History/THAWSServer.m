//
//  THAWSServer.m
//  History
//
//  Created by Srikanth Sombhatla on 19/01/17.
//  Copyright © 2017 Srikanth Sombhatla. All rights reserved.
//

#import "THAWSServer.h"
#import "THCoreConstants.h"
#import "DCTheme.h"
#import "NSString+Additions.h"
#import "THTodayModel.h"

@implementation THAWSServer

- (void)fetchTodayWithCompletionBlock:(void(^)(THTodayModel* model, NSError* error))completionBlock {
    // TODO: construct url based on env
    NSURL *URL = [NSURL URLWithString:@"https://s3.amazonaws.com/com.deviceworks.history/dev/today.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      THTodayModel* model = nil;
                                      if (!error) {
                                          NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                          if (!error) {
                                              NSLog(@"%@", jsonResponse);
                                              NSDictionary* dict = [self prepareDictionaryFromResponse:jsonResponse];
                                              model = [[THTodayModel alloc] initWithDictionary:dict];
                                          }
                                      }
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          completionBlock(model, error);
                                      });
                                  }];
    [task resume];
}

- (NSDictionary*)prepareDictionaryFromResponse:(NSDictionary*)response {
    NSMutableDictionary* dict = [NSMutableDictionary new];
    NSString* content = [response valueForKey:kContent];
    dict[kContextRawText] = content;
    dict[kTitle] = response[kTitle];
    // This is an expensive op since it requires spinning a webview. So doing it once before preparing the model.
    // TODO: See if model preparation can be done in Logic ?
    // TODO: This is a code smell. Having theme to prepare model ?
    dict[kContent] = [content attributedStringWithFont:[DCTheme fontForBody]];
    return dict;
}

@end
