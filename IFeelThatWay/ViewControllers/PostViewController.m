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
#import "CommentUtil.h"

@interface PostViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *question;
@property (strong, nonatomic) IBOutlet UITableView *questionTableView;
@property (strong, nonatomic) NSMutableArray *commentsArray;
@property (strong, nonatomic) IBOutlet UITextView *commentText;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UIView *subCommentView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property CGFloat keyboardHeight;
@property (strong, nonatomic) NSNumber *keyboardDuration;
@property bool keyboardUp;
@property (weak, nonatomic) NSString *currentLimit;
@property CGFloat oldHeight;
@property CGFloat difference;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.questionTableView.delegate = self;
    self.questionTableView.dataSource = self;
    
    self.question.text = self.prompt[@"question"];
    self.keyboardUp = NO;
    self.oldHeight = 0;
    self.difference = 0;
    
    self.currentLimit = [NSString stringWithFormat: @"%d", 20];
    [self loadQueryComments:20];
    
    self.refreshControl = [[UIRefreshControl alloc ] init];
    [self.refreshControl addTarget:self action:@selector(loadQueryComments:) forControlEvents:UIControlEventValueChanged];
    [self.questionTableView insertSubview:self.refreshControl atIndex:0];
    [self.questionTableView addSubview:self.refreshControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    self.commentButton.layer.cornerRadius = 0.5 * self.commentButton.bounds.size.width;
    self.commentText.layer.cornerRadius = 0.02 * self.commentText.bounds.size.width;
}

- (IBAction)longPressToReport:(id)sender {
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.questionTableView indexPathForCell:tappedCell];
    Comment *comment = self.commentsArray[indexPath.row];
    
    [CommentUtil reportMessage:comment :self];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    self.keyboardDuration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    self.keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    NSString *inputMethod = [[UITextInputMode currentInputMode] primaryLanguage];
    BOOL isEmoji = [inputMethod isEqualToString:@"emoji"];
    if (isEmoji)
    {
        self.difference = self.keyboardHeight - self.oldHeight;
        [UIView animateWithDuration: [self.keyboardDuration doubleValue] animations:^{
            CGRect textFrame = self.commentText.frame;
            textFrame.origin.y -= self.keyboardHeight - self.oldHeight;
            self.commentText.frame = textFrame;
            CGRect buttonFrame = self.commentButton.frame;
            buttonFrame.origin.y -= self.keyboardHeight - self.oldHeight;
            self.commentButton.frame = buttonFrame;
            CGRect viewFrame = self.subCommentView.frame;
            viewFrame.origin.y -= self.keyboardHeight - self.oldHeight;
            self.subCommentView.frame = viewFrame;
        }];
    }
    else{
        [UIView animateWithDuration: [self.keyboardDuration doubleValue] animations:^{
            CGRect textFrame = self.commentText.frame;
            textFrame.origin.y += self.difference;
            self.commentText.frame = textFrame;
            CGRect buttonFrame = self.commentButton.frame;
            buttonFrame.origin.y += self.difference;
            self.commentButton.frame = buttonFrame;
            CGRect viewFrame = self.subCommentView.frame;
            viewFrame.origin.y += self.difference;
            self.subCommentView.frame = viewFrame;
        }];
    }
}

- (IBAction)commentTextBoxTapped:(UITapGestureRecognizer *)sender {
    [self.commentText becomeFirstResponder];
    [self moveTextUp:self.keyboardHeight];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self moveTextDown:self.keyboardHeight];
}

- (IBAction)commentTapped:(id)sender {
    [self createNewComment];
}

- (void) moveTextUp: (int)height {
    if(!self.keyboardUp){
        [UIView animateWithDuration: [self.keyboardDuration doubleValue] animations:^{
            CGRect textFrame = self.commentText.frame;
            textFrame.origin.y -= height + self.difference;
            self.commentText.frame = textFrame;
            CGRect buttonFrame = self.commentButton.frame;
            buttonFrame.origin.y -= height + self.difference;
            self.commentButton.frame = buttonFrame;
            CGRect viewFrame = self.subCommentView.frame;
            viewFrame.origin.y  -= height + self.difference;
            self.subCommentView.frame = viewFrame;
        }];
        self.keyboardUp = YES;
    }
    self.oldHeight = self.keyboardHeight;
}

- (void) moveTextDown: (int)height {
    if(self.keyboardUp){
        [UIView animateWithDuration: [self.keyboardDuration doubleValue] animations:^{
            CGRect textFrame = self.commentText.frame;
            textFrame.origin.y += height;
            self.commentText.frame = textFrame;
            CGRect buttonFrame = self.commentButton.frame;
            buttonFrame.origin.y += height;
            self.commentButton.frame = buttonFrame;
            CGRect viewFrame = self.subCommentView.frame;
            viewFrame.origin.y  += height;
            self.subCommentView.frame = viewFrame;
        }];
        self.keyboardUp = NO;
    }
    self.oldHeight = self.keyboardHeight;
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
        
        self.prompt.commentsCount = [NSNumber numberWithLong:self.commentsArray.count];
        
        [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self loadQueryComments:20];
                self.commentText.text = @"";
                [self.view endEditing:YES];
                [self moveTextDown: self.keyboardHeight];
                
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

- (void) loadQueryComments: (int)numberCount{
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query includeKey:@"author"];
    [query includeKey:@"user"];
    [query whereKey:@"post" equalTo:self.prompt];
    [query orderByDescending:@"createdAt"];
    query.limit = numberCount;
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
    User *user = [PFUser currentUser];
    
    [CommentUtil designComment:user:cell:commentInfo];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentsArray.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row + 1 == [self.commentsArray count] && self.commentsArray.count >= [self.currentLimit intValue]){
        NSUInteger *count = (long)self.commentsArray.count;
        count += 20;
        self.currentLimit = [NSString stringWithFormat:@"%d", count];
        [self loadQueryComments:count];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self moveTextDown: self.keyboardHeight];
    if ([segue.identifier isEqual:@"questionToComment"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.questionTableView indexPathForCell:tappedCell];
        Comment *comment = self.commentsArray[indexPath.row];
        CommentViewController *commentViewController = [segue destinationViewController];
        commentViewController.comment = comment;
    }
}

@end
