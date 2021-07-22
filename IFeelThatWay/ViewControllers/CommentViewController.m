//
//  CommentViewController.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/14/21.
//

#import "CommentViewController.h"
#import "ReplyCell.h"
#import "Reply.h"
#import "Report.h"
#import "MBProgressHUD.h"

@interface CommentViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *commentsTableView;
@property (strong, nonatomic) NSMutableArray *repliesArray;
@property (strong, nonatomic) IBOutlet UILabel *commentPrompt;
@property (strong, nonatomic) IBOutlet UITextView *replyText;
@property (strong, nonatomic) IBOutlet UIButton *replyButton;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property CGFloat keyboardHeight;
@property (strong, nonatomic) NSNumber *keyboardDuration;
@property bool keyboardUp;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.commentsTableView.delegate = self;
    self.commentsTableView.dataSource = self;
    
    self.commentPrompt.text = self.comment[@"text"];
    self.keyboardUp = NO;
    
    [self loadQueryReplies];
    
    self.refreshControl = [[UIRefreshControl alloc ] init];
    [self.refreshControl addTarget:self action:@selector(loadQueryReplies) forControlEvents:UIControlEventValueChanged];
    [self.commentsTableView insertSubview:self.refreshControl atIndex:0];
    [self.commentsTableView addSubview:self.refreshControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (IBAction)longPressToReport:(id)sender {
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.commentsTableView indexPathForCell:tappedCell];
    Reply *reply = self.repliesArray[indexPath.row];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Would you like to report this message?" message:reply.text preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                      }];
    [alert addAction:cancelAction];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Report"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        Report *report = [Report new];
        report.message = reply.text;
        report.messageAuthor = reply[@"user"];
        report.replyId = reply;
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
    //NSNumber *curve = [notification.userInfo objectForKey: UIKeyboardAnimationCurveUserInfoKey];
    self.keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
}

- (IBAction)backTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self moveTextDown];
}

- (IBAction)replyTextBoxTapped:(id)sender {
    [self.replyText becomeFirstResponder];
    [self moveTextUp];
}

- (void) moveTextUp{
    if(!self.keyboardUp){
        [UIView animateWithDuration: [self.keyboardDuration doubleValue] animations:^{
            CGRect textFrame = self.replyText.frame;
            textFrame.origin.y -= self.keyboardHeight;
            self.replyText.frame = textFrame;
            CGRect buttonFrame = self.replyButton.frame;
            buttonFrame.origin.y -= self.keyboardHeight;
            self.replyButton.frame = buttonFrame;
        }];
        self.keyboardUp = YES;
    }
}

- (void) moveTextDown{
    if(self.keyboardUp){
        [UIView animateWithDuration: [self.keyboardDuration doubleValue] animations:^{
            CGRect textFrame = self.replyText.frame;
            textFrame.origin.y += self.keyboardHeight;;
            self.replyText.frame = textFrame;
            CGRect buttonFrame = self.replyButton.frame;
            buttonFrame.origin.y += self.keyboardHeight;;
            self.replyButton.frame = buttonFrame;
        }];
        self.keyboardUp = NO;
    }
}

- (IBAction)replyTapped:(id)sender {
    [self createNewReply];
}

- (void) createNewReply {
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
                [self.view endEditing:YES];
                [self moveTextDown];
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
        [self.refreshControl endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReplyCell *cell = (ReplyCell *)[tableView dequeueReusableCellWithIdentifier:@"ReplyCell" forIndexPath:indexPath];
    
    Reply *replyInfo = self.repliesArray[indexPath.row];
    cell.replyCell = replyInfo;
    
    cell.text.text = replyInfo[@"text"];
    
    cell.agreesCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)cell.replyCell.agreesArray.count];
    
    UIImage * colorPicture = [UIImage imageNamed:replyInfo[@"user"][@"profilePicture"]];
    [cell.profilePic setImage:colorPicture];
    cell.profilePic.layer.cornerRadius =  cell.profilePic.frame.size.width / 2;
    cell.profilePic.clipsToBounds = true;
    
    User *user = [PFUser currentUser];
    if([cell.replyCell[@"agreesArray"] containsObject: user.objectId]){
        [cell.handRaiseButton setImage:[UIImage systemImageNamed:@"hand.raised.fill"] forState:UIControlStateNormal];
    }
    else{
        [cell.handRaiseButton setImage:[UIImage systemImageNamed:@"hand.raised"] forState:UIControlStateNormal];
    }
    if([cell.replyCell[@"savesArray"] containsObject: user.objectId]){
        [cell.saveButton setImage:[UIImage systemImageNamed:@"bookmark.fill"] forState:UIControlStateNormal];
    }
    else{
        [cell.saveButton setImage:[UIImage systemImageNamed:@"bookmark"] forState:UIControlStateNormal];
    }
    
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
