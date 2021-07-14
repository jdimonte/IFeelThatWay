//
//  CommentViewController.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/14/21.
//

#import "CommentViewController.h"
#import "ReplyCell.h"

@interface CommentViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *commentsTableView;
@property (strong, nonatomic) NSMutableArray *repliesArray;
@property (strong, nonatomic) IBOutlet UILabel *commentPrompt;
@property (strong, nonatomic) IBOutlet UITextView *replyText;
@property (strong, nonatomic) IBOutlet UIButton *replyButton;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commentsTableView.delegate = self;
    self.commentsTableView.dataSource = self;
    self.commentPrompt.text = self.comment[@"text"];
    
    [self loadQueryReplies];
}

- (IBAction)backTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void) loadQueryReplies{
    PFQuery *query = [PFQuery queryWithClassName:@"Reply"];

    [query includeKey:@"author"];
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
        //[self.activityIndicator stopAnimating];
        //[self.refreshControl endRefreshing];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReplyCell *cell = (ReplyCell *)[tableView dequeueReusableCellWithIdentifier:@"ReplyCell" forIndexPath:indexPath];
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
