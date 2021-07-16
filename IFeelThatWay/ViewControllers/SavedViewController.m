//
//  SavedViewController.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import "SavedViewController.h"
#import "SavedCommentCell.h"
#import "Comment.h"
#import "MBProgressHUD.h"

@interface SavedViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *savedTableView;
@property (strong, nonatomic) NSMutableArray *savedArray;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation SavedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.savedTableView.dataSource = self;
    self.savedTableView.delegate = self;
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
    
    [self loadQueryComments];
    self.refreshControl = [[UIRefreshControl alloc ] init];
    [self.refreshControl addTarget:self action:@selector(loadQueryComments) forControlEvents:UIControlEventValueChanged];
    [self.savedTableView insertSubview:self.refreshControl atIndex:0];
    [self.savedTableView addSubview:self.refreshControl];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        self.tabBarController.selectedIndex = 2;
    }
}

- (void) loadQueryComments{
    User *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query includeKey:@"author"];
    [query includeKey:@"user"];
    [query includeKey:@"savesArray"];
    [query whereKey:@"savesArray" equalTo:user.objectId];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        if (comments != nil) {
            self.savedArray = comments;
            [self.savedTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SavedCommentCell *cell = (SavedCommentCell *)[tableView dequeueReusableCellWithIdentifier:@"SavedCommentCell" forIndexPath:indexPath];
    Comment *comment = self.savedArray[indexPath.row];
    cell.text.text = comment[@"text"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.savedArray.count;
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
