//
//  ComposeTweetViewController.m
//  tweet
//
//  Created by Chris Guzman on 11/9/15.
//  Copyright © 2015 Chris Guzman. All rights reserved.
//

#import "ComposeTweetViewController.h"
#import "TwitterClient.h"
#import "TweetsViewController.h"

@interface ComposeTweetViewController ()
@property (weak, nonatomic) IBOutlet UIButton *postTweetBtn;
@property (weak, nonatomic) IBOutlet UITextView *tweetText;

@end

@implementation ComposeTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetText.layer.borderWidth = 5.0f;
    self.tweetText.layer.borderColor = [[UIColor grayColor] CGColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelPressed)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Post Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(postTweet)];
    if (self.replyScreenName != nil) {
        self.tweetText.text = self.replyScreenName;
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)postTweet {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"status": self.tweetText.text
                                                                                }];
    if (self.replyID != nil) {
        dict[@"in_reply_to_status_id"] = self.replyID;
    }
    
    NSDictionary *params = [NSDictionary dictionaryWithDictionary:dict];
    [[TwitterClient sharedInstance] postTweet:params completion:^(NSString *message, NSError *error) {

        [self dismissViewControllerAnimated:YES completion:nil];
        if (error!= nil)
            NSLog(@"Error %@", error);
    }];
}
- (void)onCancelPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
