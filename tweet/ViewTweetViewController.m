//
//  ViewTweetViewController.m
//  tweet
//
//  Created by Chris Guzman on 11/9/15.
//  Copyright © 2015 Chris Guzman. All rights reserved.
//

#import "ViewTweetViewController.h"

@interface ViewTweetViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tweetBox;

@end

@implementation ViewTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetBox.text = self.tweet.text;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
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

@end
