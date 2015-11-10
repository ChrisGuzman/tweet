//
//  TweetViewCell.m
//  tweet
//
//  Created by Chris Guzman on 11/9/15.
//  Copyright © 2015 Chris Guzman. All rights reserved.
//

#import "TweetViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation TweetViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUpTweet:(Tweet *)tweet{
    self.tweetText.text = tweet.text;
    self.handle.text = [NSString stringWithFormat:@"@%@", tweet.user.screenname];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"M/d/yy";
    
    self.tweetDate.text = [formatter stringFromDate:tweet.createdAt];
    formatter.dateFormat = @"h:m a";
    self.tweetTime.text = [formatter stringFromDate:tweet.createdAt];
    
    NSURL *url = [NSURL URLWithString:tweet.user.profileImageUrl];
    [self.profileImage setImageWithURL:url];
}

@end
