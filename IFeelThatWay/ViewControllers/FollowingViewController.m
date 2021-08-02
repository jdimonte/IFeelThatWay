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
@property (nonatomic, strong) PFQuery *topicsFollowingQuery;
@property (nonatomic, strong) Comment *featuredComment;
@property (weak, nonatomic) NSString *currentLimit;
@property (strong, nonatomic) IBOutlet UISwitch *sortSwitch;

@end

@implementation FollowingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.followingTableView.dataSource = self;
    self.followingTableView.delegate = self;
    
    self.currentLimit = [NSString stringWithFormat: @"%d", 20];
    [self loadQueryPrompts:20];
    
    self.refreshControl = [[UIRefreshControl alloc ] init];
    [self.refreshControl addTarget:self action:@selector(loadQueryPrompts) forControlEvents:UIControlEventValueChanged];
    [self.followingTableView insertSubview:self.refreshControl atIndex:0];
    [self.followingTableView addSubview:self.refreshControl];
}

- (IBAction)sortSwitchChanged:(id)sender {
    [self loadQueryPrompts:20];
}

- (void) loadQueryPrompts: (int)numberCount {
    [self loadTopicsFollowing];
    [self loadPromptsFollowing:numberCount];
}

- (void) loadTopicsFollowing {
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
    self.topicsFollowingQuery = topicsQuery;
}

- (void) loadPromptsFollowing: (int)numberCount {
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Prompt"];
    [postQuery includeKey:@"author"];
    [postQuery includeKey:@"topic"];
    [postQuery whereKey:@"topic" matchesKey:@"category" inQuery:self.topicsFollowingQuery];
    if(self.sortSwitch.on){
        [postQuery orderByDescending:@"commentsCount"];
    }
    else{
        [postQuery orderByDescending:@"createdAt"];
    }
    postQuery.limit = numberCount;
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
    
    [self designFeaturedComment:promptInfo:cell];
    
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

- (void) designFeaturedComment:(Prompt *)individualPrompt:(FollowingPromptCell *)cell{
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query includeKey:@"author"];
    [query includeKey:@"user"];
    [query whereKey:@"post" equalTo:individualPrompt];
    [query orderByDescending:@"agreesCount"];
    query.limit = 1;
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        if (comments != nil && comments.count != 0) {
            Comment *featured = comments[0];
            cell.featuredComment.text = featured[@"text"];
            UIImage * colorPicture = [UIImage imageNamed:featured[@"user"][@"profilePicture"]];
            [cell.featuredProfilePic setImage:colorPicture];
        } else {
            NSLog(@"%@", error.localizedDescription);
            cell.featuredComment.text = @"Be the first to comment!";
            [cell.featuredProfilePic setImage:[UIImage imageNamed:@"stickerBackgroundImage"]];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.promptsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Prompt *prompt = self.promptsArray[indexPath.row];
    if(prompt.hasComments){
        return 370;
    } else{
        return 300;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row + 1 == [self.promptsArray count] && self.promptsArray.count >= [self.currentLimit intValue]){
        NSUInteger *count = (long)self.promptsArray.count;
        count += 20;
        self.currentLimit = [NSString stringWithFormat:@"%d", count];
        [self loadQueryPrompts:count];
    }
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
