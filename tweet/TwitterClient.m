//
//  TwitterClient.m
//  tweet
//
//  Created by Chris Guzman on 11/8/15.
//  Copyright © 2015 Chris Guzman. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString * const kTwitterConsumerKey = @"l6U8wnzrRJ94Dc0zz1rPlkWVs";
NSString * const kTwitterConsumerSecret = @"XZYZ6G3g0MA2yjFsJdkMIcmtKdvp3XJ6VkPWmMKahK8G9vs4rK";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end

@implementation TwitterClient

+ (TwitterClient *)sharedInstance {
    static TwitterClient *instance = nil;
    
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }

    });
    

    
    return instance;
}

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion{
    self.loginCompletion = completion;
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"Got the request token");
        
        NSURL *authURL  = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        
        [[UIApplication  sharedApplication] openURL:authURL];
    } failure:^(NSError *error) {
        NSLog(@"Failed to get the request token");
        self.loginCompletion(nil, error);
    }];
}

-(void)openURL:(NSURL *)url{
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"got the acces token");
        [self.requestSerializer saveAccessToken:accessToken];
        
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            User *user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];
            NSLog(@"current user: %@", user.name);
            self.loginCompletion(user, nil);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSLog(@"failed to get user");
            self.loginCompletion(nil, error);
        }];
        
//        [[TwitterClient sharedInstance] GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//            //            NSLog(@"Timeline is %@", responseObject);
//            NSArray *tweets = [Tweet tweetsWithArray:responseObject];
//            for (Tweet *tweet in tweets) {
//                NSLog(@"tweet: %@, created: %@", tweet.text, tweet.createdAt);
//            }
//        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//            NSLog(@"couldn't get timeline");
//        }];
    } failure:^(NSError *error) {
        NSLog(@"failed to get access token");
        self.loginCompletion(nil, error);
    }];
}

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion{
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        completion(nil, error);
    }];
    
}

- (void)postTweet:(NSDictionary *)params completion:(void (^)(NSString *message, NSError *error))completion{
    [self POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        completion(@"Success!", nil);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}


@end
