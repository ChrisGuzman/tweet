//
//  ViewTweetViewController.m
//  tweet
//
//  Created by Chris Guzman on 11/9/15.
//  Copyright © 2015 Chris Guzman. All rights reserved.
//

#import "ViewTweetViewController.h"
#import "TwitterClient.h"
#import "ComposeTweetViewController.h"

@interface ViewTweetViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tweetBox;

@end

@implementation ViewTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetBox.text = self.tweet.text;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)reply:(id)sender {
    ComposeTweetViewController *vc = [[ComposeTweetViewController alloc] init];
    vc.replyID = self.tweet.id;
    vc.replyScreenName = [NSString stringWithFormat:@"@%@", self.tweet.user.screenname];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}
- (IBAction)retweet:(id)sender {
    [[TwitterClient sharedInstance] retweet:self.tweet.id completion:^(NSString *message, NSError *error) {
        [self goBack];
    }];
}

- (IBAction)favorite:(id)sender {
    NSDictionary *params = @{
                             @"id": self.tweet.id
                             };
    [[TwitterClient sharedInstance] favorite:params completion:^(NSString *message, NSError *error) {
        [self goBack];
    }];
}
@end
