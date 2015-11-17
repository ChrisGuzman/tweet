//
//  TweetViewCell.m
//  tweet
//
//  Created by Chris Guzman on 11/9/15.
//  Copyright © 2015 Chris Guzman. All rights reserved.
//

#import "TweetViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "ProflieViewController.h"

@implementation TweetViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)onButtonPress:(id)sender {
    ProflieViewController *vc = [[ProflieViewController alloc] init];
    vc.user = self.tweet.user;
    NSLog(@"pressed");
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
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [tap setNumberOfTapsRequired:1];
    [self.profileImage addGestureRecognizer:tap];
    
}

-(void) tapAction {
    NSLog(@"profile pic tapped");
}
//- (IBAction)onProfileTapped:(UITapGestureRecognizer *)sender {
//    NSLog(@"Profile pic tapped!");
//}

@end
