//
//  TweetViewCell.h
//  tweet
//
//  Created by Chris Guzman on 11/9/15.
//  Copyright © 2015 Chris Guzman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol TweetCellDelegate <NSObject>


@optional
- (void)shouldShowProfile:(User *)user;

@end
@interface TweetViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *handle;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *tweetTime;
@property (weak, nonatomic) IBOutlet UILabel *tweetDate;
@property (weak, nonatomic) Tweet * tweet;
@property (weak, nonatomic) id<TweetCellDelegate> delegate;
@property (nonatomic, copy) void (^buttonTapAction)(id sender);
@property (weak, nonatomic) IBOutlet UIButton *profileButton;

-(void)setUpTweet:(Tweet *) tweet;

@end
