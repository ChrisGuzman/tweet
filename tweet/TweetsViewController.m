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

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *timelineTweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.timelineTweets = [[NSMutableArray alloc] init];
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self fetchTweets];
    
}

-(void)fetchTweets {
    NSDictionary *params = @{
                             @"count": @25
                             };
    
    [[TwitterClient sharedInstance] homeTimelineWithParams:params completion:^(NSArray *tweets, NSError *error) {
        [self.timelineTweets removeAllObjects];
        [self.timelineTweets addObjectsFromArray:tweets];
        for (Tweet *tweet in tweets) {
                        NSLog(@"text: %@", tweet.user.profileImageUrl);
        }
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }];
}

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
    TweetViewCell *cell = [[TweetViewCell alloc] init];
    Tweet *tweet = [self.timelineTweets objectAtIndex:indexPath.row];
    [cell setUpTweet:tweet];
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
