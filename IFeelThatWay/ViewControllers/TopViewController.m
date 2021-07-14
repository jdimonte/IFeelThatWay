//
//  TopViewController.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import "TopViewController.h"
#import "TopCommentCell.h"
#import "Comment.h"

@interface TopViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *topCommentsTableView;
@property (strong, nonatomic) NSMutableArray *topCommentsArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end

@implementation TopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.activityIndicator startAnimating];
    
    self.topCommentsTableView.delegate = self;
    self.topCommentsTableView.dataSource = self;
    
    [self loadQueryTopComments];
    
    self.refreshControl = [[UIRefreshControl alloc ] init];
    [self.refreshControl addTarget:self action:@selector(loadQueryTopComments) forControlEvents:UIControlEventValueChanged];
    [self.topCommentsTableView insertSubview:self.refreshControl atIndex:0];
    [self.topCommentsTableView addSubview:self.refreshControl];
}

- (void) loadQueryTopComments{
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];

    [query includeKey:@"author"];
    [query orderByDescending:@"agreesCount"];

    query.limit = 10;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        if (comments != nil) {
            self.topCommentsArray = comments;
            [self.topCommentsTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.activityIndicator stopAnimating];
        [self.refreshControl endRefreshing];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TopCommentCell *cell = (TopCommentCell *)[tableView dequeueReusableCellWithIdentifier:@"TopCommentCell" forIndexPath:indexPath];
    Comment *topComment = self.topCommentsArray[indexPath.row];
    NSInteger *rank = indexPath.row + 1;
    NSString *rankStr = [NSString stringWithFormat:@"%d", rank];
    NSString *rankString = [rankStr stringByAppendingString:@". "];
    NSString *commentString = topComment[@"text"];
    if(commentString){
        cell.comment.text = [rankString stringByAppendingString:commentString];
    }
    else{
        cell.comment.text = rankString;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.topCommentsArray.count;
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
