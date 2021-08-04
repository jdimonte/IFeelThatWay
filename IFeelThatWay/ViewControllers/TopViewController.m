//
//  TopViewController.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import "TopViewController.h"
#import "TopCommentCell.h"
#import "Comment.h"
#import "MBProgressHUD.h"
#import "SceneDelegate.h"

@interface TopViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *topCommentsTableView;
@property (strong, nonatomic) NSMutableArray *topCommentsArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *topContent;

@end

@implementation TopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.topCommentsTableView.delegate = self;
    self.topCommentsTableView.dataSource = self;
    
    [self loadQueryTopComments];
    
    self.refreshControl = [[UIRefreshControl alloc ] init];
    [self.refreshControl addTarget:self action:@selector(loadQueryTopComments) forControlEvents:UIControlEventValueChanged];
    [self.topCommentsTableView insertSubview:self.refreshControl atIndex:0];
    [self.topCommentsTableView addSubview:self.refreshControl];
    
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
    [self.topCommentsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //UIFont *font = [UIFont boldSystemFontOfSize:12.0f]; font forKey:NSFontAttributeName
    if(self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight){ //FIX
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
        [self.topContent setTitleTextAttributes:attributes forState:UIControlStateNormal];
        NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        [self.topContent setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    }
    
    //Commented out for less parse calls during development
    //[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(loadQueryTopComments) userInfo:nil repeats:true];
}

- (IBAction)contentTypeSwitched:(id)sender {
    [self loadQueryTopComments];
}

- (void) loadQueryTopComments{
    NSString *contentTypes[] = {@"Comment", @"Reply"};
    NSString *contentType = contentTypes[self.topContent.selectedSegmentIndex];
    PFQuery *query = [PFQuery queryWithClassName:contentType];
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
        [self.refreshControl endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TopCommentCell *cell = (TopCommentCell *)[tableView dequeueReusableCellWithIdentifier:@"TopCommentCell" forIndexPath:indexPath];
    Comment *topComment = self.topCommentsArray[indexPath.row];
    cell.commentCell = topComment;
    cell.agreesCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)cell.commentCell.agreesArray.count];
    cell.rank.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    cell.comment.text = topComment[@"text"];
    User *user = [PFUser currentUser];
    
    if([cell.commentCell[@"agreesArray"] containsObject: user.objectId]){
        [cell.raiseHandButton setImage:[UIImage systemImageNamed:@"hand.raised.fill"] forState:UIControlStateNormal];
    }
    else{
        [cell.raiseHandButton setImage:[UIImage systemImageNamed:@"hand.raised"] forState:UIControlStateNormal];
    }
    if([cell.commentCell[@"savesArray"] containsObject: user.objectId]){
        [cell.saveButton setImage:[UIImage systemImageNamed:@"bookmark.fill"] forState:UIControlStateNormal];
    }
    else{
        [cell.saveButton setImage:[UIImage systemImageNamed:@"bookmark"] forState:UIControlStateNormal];
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
