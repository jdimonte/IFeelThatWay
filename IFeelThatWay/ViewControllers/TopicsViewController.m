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

@interface TopicsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *topicsTableView;
@property (strong, nonatomic) NSMutableArray *topicsArray;

@end

@implementation TopicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topicsTableView.delegate = self;
    self.topicsTableView.dataSource = self;
    [self loadQueryTopics];
}

- (void) loadQueryTopics{
    PFQuery *query = [PFQuery queryWithClassName:@"Topic"];

    [query includeKey:@"author"];
    [query orderByAscending:@"createdAt"];

    query.limit = 20;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.topicsArray = posts;
            [self.topicsTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        //[self.refreshControl endRefreshing];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicCell *cell = (TopicCell *)[tableView dequeueReusableCellWithIdentifier:@"TopicCell" forIndexPath:indexPath];
    Topic *topicInfo = self.topicsArray[indexPath.row];
    NSString *category = topicInfo[@"category"];
    cell.topicCategory.text = category;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.topicsArray.count;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"topicToPrompt"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.topicsTableView indexPathForCell:tappedCell];
        Topic *topic = self.topicsArray[indexPath.row];
        TopicViewController *topicViewController = [segue destinationViewController];
        topicViewController.topic = topic;
    }
}

@end
