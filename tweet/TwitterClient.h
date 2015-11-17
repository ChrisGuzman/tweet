//
//  TwitterClient.h
//  tweet
//
//  Created by Chris Guzman on 11/8/15.
//  Copyright © 2015 Chris Guzman. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;

-(void)mentionTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;

- (void)postTweet:(NSDictionary *)params completion:(void (^)(NSString *message, NSError *error))completion;

- (void)retweet:(NSNumber *)tweetId completion:(void (^)(NSString *message, NSError *error))completion;

- (void)favorite:(NSDictionary *)params completion:(void (^)(NSString *message, NSError *error))completion;

-(void) getUserWithParams:(NSDictionary *)params completion:(void (^)(User *user, NSError *error))completion;


@end
