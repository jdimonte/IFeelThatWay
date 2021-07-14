//
//  CommentViewController.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/14/21.
//

#import "CommentViewController.h"
#import "ReplyCell.h"
#import "Reply.h"

@interface CommentViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *commentsTableView;
@property (strong, nonatomic) NSMutableArray *repliesArray;
@property (strong, nonatomic) IBOutlet UILabel *commentPrompt;
@property (strong, nonatomic) IBOutlet UITextView *replyText;
@property (strong, nonatomic) IBOutlet UIButton *replyButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.activityIndicator startAnimating];
    
    self.commentsTableView.delegate = self;
    self.commentsTableView.dataSource = self;
    self.commentPrompt.text = self.comment[@"text"];
    
    [self loadQueryReplies];
    
    self.refreshControl = [[UIRefreshControl alloc ] init];
    [self.refreshControl addTarget:self action:@selector(loadQueryReplies) forControlEvents:UIControlEventValueChanged];
    [self.commentsTableView insertSubview:self.refreshControl atIndex:0];
    [self.commentsTableView addSubview:self.refreshControl];
}

- (IBAction)backTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)replyTapped:(id)sender {
    if(![self.replyText.text isEqual:@""]){
        Reply *reply = [Reply new];
        
        reply.text = self.replyText.text;
        User *user = [PFUser currentUser];
        reply.user = user;
        Comment *comment = self.comment;
        reply.comment = comment;
        reply.agreesCount = 0;
        
        [reply saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self loadQueryReplies];
                self.replyText.text = @"";
            }
            else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
}


- (void) loadQueryReplies{
    PFQuery *query = [PFQuery queryWithClassName:@"Reply"];

    [query includeKey:@"author"];
    [query includeKey:@"user"];
    [query whereKey:@"comment" equalTo:self.comment];
    [query orderByDescending:@"createdAt"];

    query.limit = 20;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *replies, NSError *error) {
        if (replies != nil) {
            self.repliesArray = replies;
            [self.commentsTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.activityIndicator stopAnimating];
        [self.refreshControl endRefreshing];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReplyCell *cell = (ReplyCell *)[tableView dequeueReusableCellWithIdentifier:@"ReplyCell" forIndexPath:indexPath];
    
    Reply *replyInfo = self.repliesArray[indexPath.row];
    
    cell.text.text = replyInfo[@"text"];
    
    UIImage * colorPicture = [UIImage imageNamed:replyInfo[@"user"][@"profilePicture"]];
    [cell.profilePic setImage:colorPicture];
    cell.profilePic.layer.cornerRadius =  cell.profilePic.frame.size.width / 2;
    cell.profilePic.clipsToBounds = true;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.repliesArray.count;
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
