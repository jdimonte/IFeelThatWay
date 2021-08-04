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


@interface SavedViewController () <UITableViewDelegate, UITableViewDataSource, SavedViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *savedTableView;
@property (strong, nonatomic) NSMutableArray *savedArray;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *savedContent;

@end

@implementation SavedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.savedTableView.dataSource = self;
    self.savedTableView.delegate = self;
    
    [self loadQueryComments];
    self.refreshControl = [[UIRefreshControl alloc ] init];
    [self.refreshControl addTarget:self action:@selector(loadQueryComments) forControlEvents:UIControlEventValueChanged];
    [self.savedTableView insertSubview:self.refreshControl atIndex:0];
    [self.savedTableView addSubview:self.refreshControl];
    
    [self.savedTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    if(self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight){ //FIX
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
        [self.savedContent setTitleTextAttributes:attributes forState:UIControlStateNormal];
        NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        [self.savedContent setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    }
}

- (IBAction)contentTypeSwitched:(id)sender {
    [self loadQueryComments];
}

- (void) loadQueryComments{
    NSString *contentTypes[] = {@"Comment", @"Reply"};
    NSString *contentType = contentTypes[self.savedContent.selectedSegmentIndex];
    
    User *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:contentType];
    [query includeKey:@"author"];
    [query includeKey:@"user"];
    [query includeKey:@"savesArray"];
    [query whereKey:@"savesArray" equalTo:user.objectId];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray *content, NSError *error) {
        if (content != nil) {
            self.savedArray = content;
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
    cell.comment = comment;
    cell.bulletPoint.layer.cornerRadius =  cell.bulletPoint.frame.size.width / 2;
    cell.bulletPoint.clipsToBounds = true;
    cell.savedViewController = self;
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
