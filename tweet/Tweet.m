//
//  Tweet.m
//  tweet
//
//  Created by Chris Guzman on 11/9/15.
//  Copyright © 2015 Chris Guzman. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

-(id)initWithDictionary:(NSDictionary *) dictionary {
    self = [super init];
    if (self) {
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.text = dictionary[@"text"];
        
        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        
        self.createdAt = [formatter dateFromString:createdAtString];
//        self.createdAt = createdAtString;

    }
    return self;
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject: [[Tweet alloc] initWithDictionary:dictionary]];
    }
    
    return tweets;
}

@end
