//
//  TweetsViewController.m
//  tweet
//
//  Created by Chris Guzman on 11/9/15.
//  Copyright © 2015 Chris Guzman. All rights reserved.
//

#import "TweetsViewController.h"
#import "User.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "ComposeTweetViewController.h"
#import "ViewTweetViewController.h"
#import "TweetViewCell.h"
#import "ProflieViewController.h"

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *timelineTweets;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMarginConstraint;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property CGFloat originalLeftMargin;
@property (strong, nonatomic) ProflieViewController *profileViewController;
@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100.0;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetViewCell" bundle:nil] forCellReuseIdentifier:@"TweetViewCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.timelineTweets = [[NSMutableArray alloc] init];
//    self.menuViewController.view.frame = self.menuView.bounds;
    
    self.profileViewController = [[ProflieViewController alloc] init];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self fetchTweets];
    
}

-(void)fetchMentions {
    NSDictionary *params = @{
                             @"count": @25
                             };
    
    [[TwitterClient sharedInstance] mentionTimelineWithParams:params completion:^(NSArray *tweets, NSError *error) {
        [self.timelineTweets removeAllObjects];
        [self.timelineTweets addObjectsFromArray:tweets];
        for (Tweet *tweet in tweets) {
            //                        NSLog(@"text: %@", tweet.user.profileImageUrl);
        }
        if (error != nil) {
            NSLog(@"%@", error);
        }
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }];
}

-(void)fetchTweets {
    NSDictionary *params = @{
                             @"count": @25
                             };
    
    [[TwitterClient sharedInstance] homeTimelineWithParams:params completion:^(NSArray *tweets, NSError *error) {
        [self.timelineTweets removeAllObjects];
        [self.timelineTweets addObjectsFromArray:tweets];
        for (Tweet *tweet in tweets) {
//                        NSLog(@"text: %@", tweet.user.profileImageUrl);
        }
        if (error != nil) {
            NSLog(@"%@", error);
        }
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)setMenuViewController:(UINavigationController *)menuViewController {
    _menuViewController = menuViewController;
    
    [self.view layoutIfNeeded];
    [self.menuView addSubview:menuViewController.view];
}

//- (void)setContentViewController:(UINavigationController *)contentViewController {
//    _contentViewController = contentViewController;
//    
//    [self.view layoutIfNeeded];
//    [self.contentView addSubview:contentViewController.view];
//    [self close];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"This many tweets: %lu", (unsigned long)self.timelineTweets.count);
    return self.timelineTweets.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetViewCell"];
    Tweet *tweet = [self.timelineTweets objectAtIndex:indexPath.row];
    cell.tweet = tweet;
    [cell setUpTweet:tweet];
    cell.profileButton.tag = indexPath.row;
    [cell.profileButton addTarget:self action:@selector(profileButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    Tweet *tweet = [self.timelineTweets objectAtIndex:indexPath.row];
    ViewTweetViewController *vc = [[ViewTweetViewController alloc] init];
    vc.tweet = tweet;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

-(void)profileButtonClick:(id)sender{
    UIButton *senderButton = (UIButton *)sender;
    NSLog(@"current row: %ld", (long)senderButton.tag);
    Tweet *tweet = [self.timelineTweets objectAtIndex:senderButton.tag];
    User *user = tweet.user;
    [self showProfile:user];
    
}

- (IBAction)onTableViewPanned:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
    
    if ([sender state] == UIGestureRecognizerStateBegan) {
        self.originalLeftMargin = self.leftMarginConstraint.constant;
    }
    else if ([sender state] == UIGestureRecognizerStateChanged) {
        self.leftMarginConstraint.constant = self.originalLeftMargin + translation.x;
    }
    else if ([sender state] == UIGestureRecognizerStateEnded) {
        if (velocity.x > 0) {
            [self open];
        } else {
            [self close];
        }
        [self.view layoutIfNeeded];
    }
}

- (void)open {
    [UIView animateWithDuration:.3 animations:^{
        self.leftMarginConstraint.constant = self.view.frame.size.width - 100;
        [self.view layoutIfNeeded];
    }];
}

- (void)close {
    [UIView animateWithDuration:.3 animations:^{
        self.leftMarginConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

- (void)shouldShowProfile:(User *)user {
    [self showProfile:user];
}

-(void)showProfile:(User*)user {
    ProflieViewController *vc = [[ProflieViewController alloc] initWithNibName:@"ProflieViewController" bundle:nil];
    vc.user = user;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}
- (IBAction)onHomePressed:(id)sender {
    [self close];
    [self fetchTweets];
}

- (IBAction)onMentionsPressed:(id)sender {
    [self close];
    [self fetchMentions];
}
- (IBAction)onProfilePressed:(id)sender {
    [self close];
    [self showProfile:[User currentUser]];
}
- (IBAction)onMenuPressed:(id)sender {
    [self open];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onLogout:(id)sender {
    [User logout];
}

- (IBAction)composeTweet:(id)sender {
    ComposeTweetViewController *vc = [[ComposeTweetViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

@end
