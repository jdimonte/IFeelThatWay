//
//  TopicViewController.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import "TopicViewController.h"
#import "Prompt.h"
#import "PromptCell.h"
#import "PostViewController.h"
#import "Comment.h"

@interface TopicViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *category;
@property (strong, nonatomic) IBOutlet UIButton *followButton;
@property (strong, nonatomic) IBOutlet UITableView *promptsTableView;
@property (strong, nonatomic) NSMutableArray *promptsArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end

@implementation TopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.activityIndicator startAnimating];
    
    self.promptsTableView.delegate = self;
    self.promptsTableView.dataSource = self;
    
    self.category.text = self.topic[@"category"];
    
    [self loadQueryPrompts];
    
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
        //follow topic
        [self.topic addUniqueObject:user.objectId forKey:@"followersArray"];
    }
    else{
        [self.followButton setImage:[UIImage systemImageNamed:@"checkmark.square"] forState:UIControlStateNormal];
        //unfollow topic
        [self.topic removeObject:user.objectId forKey:@"followersArray"];
    }
    [self.topic saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void) loadQueryPrompts{
    PFQuery *query = [PFQuery queryWithClassName:@"Prompt"];

    [query includeKey:@"author"];
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
        [self.activityIndicator stopAnimating];
        [self.refreshControl endRefreshing];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PromptCell *cell = (PromptCell *)[tableView dequeueReusableCellWithIdentifier:@"PromptCell" forIndexPath:indexPath];
    Prompt *promptInfo = self.promptsArray[indexPath.row];
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
    if ([segue.identifier isEqual:@"promptsToQuestion"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.promptsTableView indexPathForCell:tappedCell];
        Prompt *prompt = self.promptsArray[indexPath.row];
        PostViewController *postViewController = [segue destinationViewController];
        postViewController.prompt = prompt;
    }
}

@end
