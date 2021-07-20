//
//  TopicViewController.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import "TopicViewController.h"
#import "Prompt.h"
#import "Poll.h"
#import "PromptCell.h"
#import "PollCell.h"
#import "PostViewController.h"
#import "Comment.h"
#import "MBProgressHUD.h"

@interface TopicViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *category;
@property (strong, nonatomic) IBOutlet UIButton *followButton;
@property (strong, nonatomic) IBOutlet UITableView *promptsTableView;
@property (strong, nonatomic) NSMutableArray *promptsArray;
@property (strong, nonatomic) NSMutableArray *pollsArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) Comment *featuredComment;

@end

@implementation TopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.promptsTableView.delegate = self;
    self.promptsTableView.dataSource = self;
    
    [self loadQueryPrompts];
    
    self.category.text = self.topic[@"category"];
    
    self.refreshControl = [[UIRefreshControl alloc ] init];
    [self.refreshControl addTarget:self action:@selector(loadQueryPrompts) forControlEvents:UIControlEventValueChanged];
    [self.promptsTableView insertSubview:self.refreshControl atIndex:0];
    [self.promptsTableView addSubview:self.refreshControl];
    
    User *user = [PFUser currentUser];
    if([self.topic[@"followersArray"] containsObject: user.objectId]){
        [self.followButton setImage:[UIImage systemImageNamed:@"checkmark.square.fill"] forState:UIControlStateNormal];
    }
    else{
        [self.followButton setImage:[UIImage systemImageNamed:@"checkmark.square"] forState:UIControlStateNormal];
    }
}

- (IBAction)backTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)followTapped:(id)sender {
    User *user = [PFUser currentUser];
    if(![self.topic[@"followersArray"] containsObject: user.objectId]){
        [self.followButton setImage:[UIImage systemImageNamed:@"checkmark.square.fill"] forState:UIControlStateNormal];
        [self.topic addUniqueObject:user.objectId forKey:@"followersArray"];
    }
    else{
        [self.followButton setImage:[UIImage systemImageNamed:@"checkmark.square"] forState:UIControlStateNormal];
        [self.topic removeObject:user.objectId forKey:@"followersArray"];
    }
    [self.topic saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void) loadQueryPrompts{
    PFQuery *query = [PFQuery queryWithClassName:@"Prompt"];

    [query includeKey:@"author"];
    [query includeKey:@"topic"];
    [query includeKey:@"question"];
    [query whereKey:@"topic" equalTo:self.topic.category];
    [query orderByDescending:@"createdAt"];

    query.limit = 20;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *prompts, NSError *error) {
        if (prompts != nil) {
            self.promptsArray = prompts;
            [self.promptsTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    PFQuery *queryPoll = [PFQuery queryWithClassName:@"Poll"];

    [queryPoll includeKey:@"author"];
    [queryPoll includeKey:@"topic"];
    [queryPoll includeKey:@"question"];
    [queryPoll includeKey:@"firstAnswer"];
    [queryPoll includeKey:@"secondAnswer"];
    [queryPoll includeKey:@"thirdAnswer"];
    [queryPoll includeKey:@"fourthAnswer"];
    [queryPoll includeKey:@"firstArray"];
    [queryPoll includeKey:@"secondArray"];
    [queryPoll includeKey:@"thirdArray"];
    [queryPoll includeKey:@"fourthArray"];
    [queryPoll whereKey:@"topic" equalTo:self.topic.category];
    [queryPoll orderByDescending:@"createdAt"];

    queryPoll.limit = 1;
    [queryPoll findObjectsInBackgroundWithBlock:^(NSArray *polls, NSError *error) {
        if (polls != nil) {
            self.pollsArray = polls;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
        [self.promptsTableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        PollCell *cell = (PromptCell *)[tableView dequeueReusableCellWithIdentifier:@"PollCell" forIndexPath:indexPath];
        Poll *pollInfo = self.pollsArray[indexPath.row];
        cell.poll = pollInfo;
        cell.question.text = pollInfo[@"question"];
        [cell.optionOne setTitle:pollInfo[@"firstAnswer"] forState:UIControlStateNormal];
        [cell.optionTwo setTitle:pollInfo[@"secondAnswer"] forState:UIControlStateNormal];
        [cell.optionThree setTitle:pollInfo[@"thirdAnswer"] forState:UIControlStateNormal];
        [cell.optionFour setTitle:pollInfo[@"fourthAnswer"] forState:UIControlStateNormal];
        
        //set percents
        //cell.optionOnePercent.text = [NSString stringWithFormat:@"%lu",(unsigned long)cell.poll.thirdArray.count];
        
        User *user = [PFUser currentUser];
        
        cell.optionOnePercent.textColor = [UIColor blackColor];
        cell.optionTwoPercent.textColor = [UIColor blackColor];
        cell.optionThreePercent.textColor = [UIColor blackColor];
        cell.optionFourPercent.textColor = [UIColor blackColor];
        
        if([pollInfo[@"firstArray"] containsObject:user.objectId]){
            cell.firstView.backgroundColor = [UIColor lightGrayColor];
        } else if ([pollInfo[@"secondArray"] containsObject:user.objectId]){
            cell.secondView.backgroundColor = [UIColor lightGrayColor];
        } else if ([pollInfo[@"thirdArray"] containsObject:user.objectId]) {
            cell.thirdView.backgroundColor = [UIColor lightGrayColor];
        } else if ([pollInfo[@"fourthArray"] containsObject:user.objectId]) {
            cell.fourthView.backgroundColor = [UIColor lightGrayColor];;
        } else {
            cell.optionOnePercent.textColor = [UIColor whiteColor];
            cell.optionTwoPercent.textColor = [UIColor whiteColor];
            cell.optionThreePercent.textColor = [UIColor whiteColor];
            cell.optionFourPercent.textColor = [UIColor whiteColor];
        }
        
        cell.featuredProfilePic.layer.cornerRadius =  cell.featuredProfilePic.frame.size.width / 2;
        cell.featuredProfilePic.clipsToBounds = true;

        
        return cell;
    }
    else{
        PromptCell *cell = (PromptCell *)[tableView dequeueReusableCellWithIdentifier:@"PromptCell" forIndexPath:indexPath];
        Prompt *promptInfo = self.promptsArray[indexPath.row-1];
        cell.promptCell = promptInfo;
        cell.question.text = promptInfo[@"question"];

        self.featuredComment = [self getFeaturedComment:promptInfo];
        if(self.featuredComment){
            cell.featuredComment.text = self.featuredComment[@"text"];
            UIImage * colorPicture = [UIImage imageNamed:self.featuredComment[@"user"][@"profilePicture"]];
            [cell.featuredProfilePic setImage:colorPicture];
        }
        
        cell.featuredProfilePic.layer.cornerRadius =  cell.featuredProfilePic.frame.size.width / 2;
        cell.featuredProfilePic.clipsToBounds = true;
        
        User *user = [PFUser currentUser];
        if([cell.promptCell[@"agreesArray"] containsObject: user.objectId]){
            [cell.handRaise setImage:[UIImage systemImageNamed:@"hand.raised.fill"] forState:UIControlStateNormal];
        }
        else{
            [cell.handRaise setImage:[UIImage systemImageNamed:@"hand.raised"] forState:UIControlStateNormal];
        }
        if([cell.promptCell[@"savesArray"] containsObject: user.objectId]){
            [cell.save setImage:[UIImage systemImageNamed:@"bookmark.fill"] forState:UIControlStateNormal];
        }
        else{
            [cell.save setImage:[UIImage systemImageNamed:@"bookmark"] forState:UIControlStateNormal];
        }
        
        return cell;
    }
}

- (Comment *) getFeaturedComment:(Prompt *)promptInfo{
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query includeKey:@"author"];
    [query includeKey:@"user"];
    [query whereKey:@"post" equalTo:promptInfo];
    [query orderByDescending:@"agreesCount"];
    query.limit = 1;
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        if (comments != nil && comments.count != 0) {
            self.featuredComment = comments[0];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    return self.featuredComment;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.promptsArray.count + 1;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"promptsToQuestion"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.promptsTableView indexPathForCell:tappedCell];
        Prompt *prompt = self.promptsArray[indexPath.row];
        PostViewController *postViewController = [segue destinationViewController];
        postViewController.prompt = prompt;
    }
}

@end
