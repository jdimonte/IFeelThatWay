//
//  PostViewController.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/13/21.
//

#import "PostViewController.h"
#import "CommentCell.h"
#import "Comment.h"
#import "CommentViewController.h"
#import "Report.h"
#import "MBProgressHUD.h"

@interface PostViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *question;
@property (strong, nonatomic) IBOutlet UITableView *questionTableView;
@property (strong, nonatomic) NSMutableArray *commentsArray;
@property (strong, nonatomic) IBOutlet UITextView *commentText;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property CGFloat keyboardHeight;
@property (strong, nonatomic) NSNumber *keyboardDuration;
@property bool keyboardUp;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.questionTableView.delegate = self;
    self.questionTableView.dataSource = self;
    
    self.question.text = self.prompt[@"question"];
    self.keyboardUp = NO;
    
    [self loadQueryComments];
    
    self.refreshControl = [[UIRefreshControl alloc ] init];
    [self.refreshControl addTarget:self action:@selector(loadQueryComments) forControlEvents:UIControlEventValueChanged];
    [self.questionTableView insertSubview:self.refreshControl atIndex:0];
    [self.questionTableView addSubview:self.refreshControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (IBAction)longPressToReport:(id)sender {
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.questionTableView indexPathForCell:tappedCell];
    Comment *comment = self.commentsArray[indexPath.row];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Would you like to report this message?" message:comment.text preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                      }];
    [alert addAction:cancelAction];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Report"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        Report *report = [Report new];
        report.message = comment.text;
        report.messageAuthor = comment[@"user"];
        report.commentId = comment;
        [report saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
            }
            else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
                                                     }];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:^{
    }];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    self.keyboardDuration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    self.keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
}

- (IBAction)commentTextBoxTapped:(id)sender {
    [self.commentText becomeFirstResponder];
    [self moveTextUp];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self moveTextDown];
}

- (IBAction)commentTapped:(id)sender {
    [self createNewComment];
}

- (void) moveTextUp{
    NSLog(@"%d", self.keyboardUp);
    if(!self.keyboardUp){
        [UIView animateWithDuration: [self.keyboardDuration doubleValue] animations:^{
            CGRect textFrame = self.commentText.frame;
            textFrame.origin.y -= self.keyboardHeight;
            NSLog(@"%lg", self.keyboardHeight);
            self.commentText.frame = textFrame;
            CGRect buttonFrame = self.commentButton.frame;
            buttonFrame.origin.y -= self.keyboardHeight;
            self.commentButton.frame = buttonFrame;
        }];
        self.keyboardUp = YES;
    }
}

- (void) moveTextDown{
    if(self.keyboardUp){
        [UIView animateWithDuration: [self.keyboardDuration doubleValue] animations:^{
            CGRect textFrame = self.commentText.frame;
            textFrame.origin.y += self.keyboardHeight;;
            self.commentText.frame = textFrame;
            CGRect buttonFrame = self.commentButton.frame;
            buttonFrame.origin.y += self.keyboardHeight;;
            self.commentButton.frame = buttonFrame;
        }];
        self.keyboardUp = NO;
    }
}

- (void) createNewComment {
    if(![self.commentText.text isEqual:@""]){
        Comment *comment = [Comment new];
        
        comment.text = self.commentText.text;
        User *user = [PFUser currentUser];
        comment.user = user;
        Prompt *prompt = self.prompt;
        comment.post = prompt;
        comment.agreesCount = 0;
        
        [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self loadQueryComments];
                self.commentText.text = @"";
                [self.view endEditing:YES];
                [self moveTextDown];
                
                if(!self.prompt.hasComments){
                    self.prompt.hasComments = !self.prompt.hasComments;
                    [self.prompt saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                        }
                        else {
                            NSLog(@"%@", error.localizedDescription);
                        }
                    }];
                }
            }
            else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
}

- (void) loadQueryComments{
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];

    [query includeKey:@"author"];
    [query includeKey:@"user"];
    [query whereKey:@"post" equalTo:self.prompt];
    [query orderByAscending:@"createdAt"];

    query.limit = 20;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        if (comments != nil) {
            self.commentsArray = comments;
            [self.questionTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (IBAction)backTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    Comment *commentInfo = self.commentsArray[indexPath.row];
    cell.commentCell = commentInfo;
    cell.text.text = commentInfo[@"text"];
    cell.agreesCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)cell.commentCell.agreesArray.count];
    
    UIImage * colorPicture = [UIImage imageNamed:commentInfo[@"user"][@"profilePicture"]];
    [cell.profilePic setImage:colorPicture];
    cell.profilePic.layer.cornerRadius =  cell.profilePic.frame.size.width / 2;
    cell.profilePic.clipsToBounds = true;
    User *user = [PFUser currentUser];
    if([cell.commentCell[@"agreesArray"] containsObject: user.objectId]){
        [cell.handRaiseButton setImage:[UIImage systemImageNamed:@"hand.raised.fill"] forState:UIControlStateNormal];
    }
    else{
        [cell.handRaiseButton setImage:[UIImage systemImageNamed:@"hand.raised"] forState:UIControlStateNormal];
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
    return self.commentsArray.count;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"questionToComment"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.questionTableView indexPathForCell:tappedCell];
        Comment *comment = self.commentsArray[indexPath.row];
        CommentViewController *commentViewController = [segue destinationViewController];
        commentViewController.comment = comment;
    }
}

@end
