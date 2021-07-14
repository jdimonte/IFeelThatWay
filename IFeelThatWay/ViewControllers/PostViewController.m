//
//  PostViewController.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/13/21.
//

#import "PostViewController.h"
#import "CommentCell.h"
#import "Comment.h"

@interface PostViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *question;
@property (strong, nonatomic) IBOutlet UITableView *questionTableView;
@property (strong, nonatomic) NSMutableArray *commentsArray;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.questionTableView.delegate = self;
    self.questionTableView.dataSource = self;
    self.question.text = self.prompt[@"question"];
    
    [self loadQueryComments];
}

- (void) loadQueryComments{
    PFQuery *query = [PFQuery queryWithClassName:@"Prompt"];

    [query includeKey:@"author"];
    [query whereKey:@"post" equalTo:self.prompt];
    [query orderByDescending:@"createdAt"];

    query.limit = 20;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        if (comments != nil) {
            self.commentsArray = comments;
            [self.questionTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        //[self.activityIndicator stopAnimating];
        //[self.refreshControl endRefreshing];
    }];
}

- (IBAction)backTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    Comment *commentInfo = self.commentsArray[indexPath.row];
    cell.text = commentInfo[@"text"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentsArray.count;
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
