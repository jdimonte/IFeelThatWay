//
//  FollowingViewController.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import "FollowingViewController.h"
#import "FollowingPromptCell.h"
#import <Parse/Parse.h>
#import "Prompt.h"
#import "PostViewController.h"
#import "User.h"
#import "Comment.h"
#import "MBProgressHUD.h"

@interface FollowingViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *followingTableView;
@property (strong, nonatomic) NSMutableArray *promptsArray;
@property (strong, nonatomic) NSMutableArray *topicsArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation FollowingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.followingTableView.dataSource = self;
    self.followingTableView.delegate = self;
    
    [self loadQueryPrompts];
    
    self.refreshControl = [[UIRefreshControl alloc ] init];
    [self.refreshControl addTarget:self action:@selector(loadQueryPrompts) forControlEvents:UIControlEventValueChanged];
    [self.followingTableView insertSubview:self.refreshControl atIndex:0];
    [self.followingTableView addSubview:self.refreshControl];
}

- (void) loadQueryPrompts{
    User *user = [PFUser currentUser];
    PFQuery *topicsQuery = [PFQuery queryWithClassName:@"Topic"];
    [topicsQuery includeKey:@"author"];
    [topicsQuery includeKey:@"followersArray"];
    [topicsQuery whereKey:@"followersArray" equalTo:user.objectId];
    topicsQuery.limit = 20;
    [topicsQuery findObjectsInBackgroundWithBlock:^(NSArray *topics, NSError *error) {
        if (topics != nil) {
            self.topicsArray = topics;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Prompt"];
    [postQuery includeKey:@"author"];
    [postQuery includeKey:@"topic"];
    [postQuery whereKey:@"topic" matchesKey:@"category" inQuery:topicsQuery];
    [postQuery orderByDescending:@"createdAt"];
    postQuery.limit = 20;
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *prompts, NSError *error) {
        if (prompts != nil) {
            self.promptsArray = prompts;
            [self.followingTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FollowingPromptCell *cell = (FollowingPromptCell *)[tableView dequeueReusableCellWithIdentifier:@"FollowingPromptCell" forIndexPath:indexPath];
    Prompt *promptInfo = self.promptsArray[indexPath.row];
    cell.promptCell = promptInfo;
    
    cell.topic.text = promptInfo[@"topic"];
    cell.question.text = promptInfo[@"question"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query includeKey:@"author"];
    [query includeKey:@"user"];
    [query whereKey:@"post" equalTo:promptInfo];
    [query orderByDescending:@"agreesCount"];
    query.limit = 1;
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        if (comments != nil && comments.count != 0) {
            Comment *featuredComment = comments[0];
            cell.featuredComment.text = featuredComment[@"text"];
            UIImage * colorPicture = [UIImage imageNamed:featuredComment[@"user"][@"profilePicture"]];
            [cell.featuredProfilePic setImage:colorPicture];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    cell.featuredProfilePic.layer.cornerRadius =  cell.featuredProfilePic.frame.size.width / 2;
    cell.featuredProfilePic.clipsToBounds = true;
    
    User *user = [PFUser currentUser];
    if([cell.promptCell[@"agreesArray"] containsObject: user.objectId]){
        [cell.handRaiseButton setImage:[UIImage systemImageNamed:@"hand.raised.fill"] forState:UIControlStateNormal];
    }
    else{
        [cell.handRaiseButton setImage:[UIImage systemImageNamed:@"hand.raised"] forState:UIControlStateNormal];
    }
    if([cell.promptCell[@"savesArray"] containsObject: user.objectId]){
        [cell.saveButton setImage:[UIImage systemImageNamed:@"bookmark.fill"] forState:UIControlStateNormal];
    }
    else{
        [cell.saveButton setImage:[UIImage systemImageNamed:@"bookmark"] forState:UIControlStateNormal];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.promptsArray.count;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"followingToQuestion"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.followingTableView indexPathForCell:tappedCell];
        Prompt *prompt = self.promptsArray[indexPath.row];
        PostViewController *postViewController = [segue destinationViewController];
        postViewController.prompt = prompt;
    }
}


@end
