//
//  LoginViewController.m
//  tweet
//
//  Created by Chris Guzman on 11/8/15.
//  Copyright © 2015 Chris Guzman. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "TweetsViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
- (IBAction)loginWithTwitter:(id)sender {
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if (user != nil) {
            //Present Tweets
            NSLog(@"Welcome to %@", user.name);
            
            [User currentUser];
            [self presentViewController:[[TweetsViewController alloc] init] animated:YES completion:nil];
        }
        else {
            //Present Error
        }
    }];
}

@end
