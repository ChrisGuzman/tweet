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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelPressed)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Post Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(postTweet)];
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
    NSDictionary *params = @{
                             @"status": self.tweetText.text
                             };
    [[TwitterClient sharedInstance] postTweet:params completion:^(NSString *message, NSError *error) {
//        TweetsViewController *vc = [[TweetsViewController alloc] init];
//        [self presentViewController:vc animated:YES completion:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}
- (void)onCancelPressed {
//    TweetsViewController *vc = [[TweetsViewController alloc] init];
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self presentViewController:vc animated:YES completion:nil];
}

@end
