//
//  TopicsViewController.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import "TopicsViewController.h"
#import "TopicViewController.h"
#import "TopicCell.h"
#import "Topic.h"
#import <Parse/Parse.h>
#import "User.h"

@interface TopicsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *topicsTableView;
@property (strong, nonatomic) NSMutableArray *topicsArray;
@property (strong, nonatomic) NSMutableArray *filteredTopicsArray;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation TopicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.activityIndicator startAnimating];
    
    self.topicsTableView.delegate = self;
    self.topicsTableView.dataSource = self;
    self.searchBar.delegate = self;

    [self loadQueryTopics];
    self.filteredTopicsArray = self.topicsArray;
    
    self.refreshControl = [[UIRefreshControl alloc ] init];
    [self.refreshControl addTarget:self action:@selector(loadQueryTopics) forControlEvents:UIControlEventValueChanged];
    [self.topicsTableView insertSubview:self.refreshControl atIndex:0];
    [self.topicsTableView addSubview:self.refreshControl];
}

- (void) loadQueryTopics{
    PFQuery *query = [PFQuery queryWithClassName:@"Topic"];

    [query includeKey:@"author"];
    [query includeKey:@"followersArray"];
    [query orderByAscending:@"createdAt"];

    query.limit = 20;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *topics, NSError *error) {
        if (topics != nil) {
            self.topicsArray = topics;
            [self.topicsTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.activityIndicator stopAnimating];
        [self.refreshControl endRefreshing];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicCell *cell = (TopicCell *)[tableView dequeueReusableCellWithIdentifier:@"TopicCell" forIndexPath:indexPath];
    cell.topic = self.topicsArray[indexPath.row];
    if(self.filteredTopicsArray){
        cell.topic = self.filteredTopicsArray[indexPath.row];
    }
    NSString *category = cell.topic[@"category"];
    cell.topicCategory.text = category;
    User *user = [PFUser currentUser];
    if([cell.topic[@"followersArray"] containsObject: user.objectId]){
        [cell.followButton setImage:[UIImage systemImageNamed:@"checkmark.square.fill"] forState:UIControlStateNormal];
    }
    else{
        [cell.followButton setImage:[UIImage systemImageNamed:@"checkmark.square"] forState:UIControlStateNormal];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.filteredTopicsArray){
        return self.filteredTopicsArray.count;
    }
    else{
        return self.topicsArray.count;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(category CONTAINS[cd] %@)", searchText];
        self.filteredTopicsArray = [self.topicsArray filteredArrayUsingPredicate:predicate];
    }
    else {
        self.filteredTopicsArray = self.topicsArray;
    }
    
    [self.topicsTableView reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"topicToPrompt"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.topicsTableView indexPathForCell:tappedCell];
        Topic *topic = self.topicsArray[indexPath.row];
        if(self.filteredTopicsArray){
            topic = self.filteredTopicsArray[indexPath.row];
        }
        TopicViewController *topicViewController = [segue destinationViewController];
        topicViewController.topic = topic;
    }
}

@end
