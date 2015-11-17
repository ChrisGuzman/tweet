//
//  ProflieViewController.m
//  tweet
//
//  Created by Chris Guzman on 11/16/15.
//  Copyright © 2015 Chris Guzman. All rights reserved.
//

#import "ProflieViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"

@interface ProflieViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageVIew;
@property (weak, nonatomic) IBOutlet UILabel *amountOfTweets;
@property (weak, nonatomic) IBOutlet UILabel *amountFollowing;
@property (weak, nonatomic) IBOutlet UILabel *amountOfFollowers;
@property (weak, nonatomic) IBOutlet UILabel *screenName;

@end

@implementation ProflieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelPressed)];
    if (self.user != nil) {
        [self fetchUser];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onCancelPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)fetchUser {
    NSDictionary *params = @{
                             @"user_id": self.user.userId,
                             @"screen_name": self.user.screenname
                             };
    [[TwitterClient sharedInstance] getUserWithParams:params completion:^(User *user, NSError *error) {
        if (user != nil) {
            NSLog(@"User is %@", user);
            NSURL *url = [NSURL URLWithString:user.profileImageUrl];
            [self.imageVIew setImageWithURL:url];
            self.amountFollowing.text = [NSString stringWithFormat:@"%@", user.friendsCount];
            self.amountOfFollowers.text = [NSString stringWithFormat:@"%@", user.followersCount];
            self.amountOfTweets.text = [NSString stringWithFormat:@"%@", user.statusesCount];
            self.screenName.text = user.screenname;
        }
        else {
            NSLog(@"Errors: %@", error);
        }
    }];
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
