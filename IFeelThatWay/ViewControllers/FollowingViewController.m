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

@interface FollowingViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *followingTableView;
@property (strong, nonatomic) NSMutableArray *promptsArray;

@end

@implementation FollowingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.followingTableView.dataSource = self;
    self.followingTableView.delegate = self;
    
    [self loadQueryPrompts];
}

- (void) loadQueryPrompts{
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Prompt"];
    User *user = [PFUser currentUser];
    [postQuery includeKey:@"author"];
    [postQuery includeKey:@"followersArray"];
    NSLog(@"%@", user.objectId);
    
    [postQuery whereKey:@"followerArray" containsString:user.objectId];
//    [topicQuery whereKey:@"followersArray"  containedIn:[@"followersArray"]]
//    [postQuery whereKey:@"followersArray" matchesKey:@"objectId" inQuery: userQuery];
//    [query whereKey:user[@"objectID"] containedIn:[@"topic"][@"followersArray"]];
    
    [postQuery orderByDescending:@"createdAt"];

    postQuery.limit = 20;
    
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *prompts, NSError *error) {
        if (prompts != nil) {
            self.promptsArray = prompts;
            [self.followingTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        //[self.activityIndicator stopAnimating];
        //[self.refreshControl endRefreshing];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FollowingPromptCell *cell = (FollowingPromptCell *)[tableView dequeueReusableCellWithIdentifier:@"FollowingPromptCell" forIndexPath:indexPath];
    Prompt *promptInfo = self.promptsArray[indexPath.row];
    cell.topic.text = promptInfo[@"topic"];
    cell.question.text = promptInfo[@"question"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query includeKey:@"author"];
    [query includeKey:@"user"];
    [query whereKey:@"post" equalTo:promptInfo];
    [query orderByDescending:@"agreesCount"];
    query.limit = 1;
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        if (comments != nil) {
            Comment *featuredComment = comments[0];
            cell.featuredComment.text = featuredComment[@"text"];
            UIImage * colorPicture = [UIImage imageNamed:featuredComment[@"user"][@"profilePicture"]];
            [cell.featuredProfilePic setImage:colorPicture];
            cell.featuredProfilePic.layer.cornerRadius =  cell.featuredProfilePic.frame.size.width / 2;
            cell.featuredProfilePic.clipsToBounds = true;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];

    
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
