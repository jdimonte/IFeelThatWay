//
//  PollViewController.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/22/21.
//

#import "PollViewController.h"
#import "CommentCell.h"
#import "Comment.h"
#import "CommentViewController.h"
#import "MBProgressHUD.h"

@interface PollViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *question;
@property (strong, nonatomic) IBOutlet UIButton *optionOne;
@property (strong, nonatomic) IBOutlet UIButton *optionTwo;
@property (strong, nonatomic) IBOutlet UIButton *optionThree;
@property (strong, nonatomic) IBOutlet UIButton *optionFour;
@property (strong, nonatomic) IBOutlet UILabel *optionOnePercent;
@property (strong, nonatomic) IBOutlet UILabel *optionTwoPercent;
@property (strong, nonatomic) IBOutlet UILabel *optionThreePercent;
@property (strong, nonatomic) IBOutlet UILabel *optionFourPercent;
@property (strong, nonatomic) IBOutlet UIView *firstView;
@property (strong, nonatomic) IBOutlet UIView *secondView;
@property (strong, nonatomic) IBOutlet UIView *thirdView;
@property (strong, nonatomic) IBOutlet UIView *fourthView;
@property (strong, nonatomic) IBOutlet UITableView *questionTableView;
@property (strong, nonatomic) NSMutableArray *commentsArray;
@property (strong, nonatomic) IBOutlet UITextView *commentText;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property CGFloat keyboardHeight;
@property (strong, nonatomic) NSNumber *keyboardDuration;
@property bool keyboardUp;

@end

@implementation PollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.questionTableView.delegate = self;
    self.questionTableView.dataSource = self;
    
    [self designPoll];
    self.keyboardUp = NO;
    
    [self loadQueryComments];
    
    self.refreshControl = [[UIRefreshControl alloc ] init];
    [self.refreshControl addTarget:self action:@selector(loadQueryComments) forControlEvents:UIControlEventValueChanged];
    [self.questionTableView insertSubview:self.refreshControl atIndex:0];
    [self.questionTableView addSubview:self.refreshControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    self.keyboardDuration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    self.keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
}

- (IBAction)backTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void) designPoll {
    self.question.text = self.poll[@"question"];
    [self.optionOne setTitle:self.poll[@"firstAnswer"] forState:UIControlStateNormal];
    [self.optionTwo setTitle:self.poll[@"secondAnswer"] forState:UIControlStateNormal];
    [self.optionThree setTitle:self.poll[@"thirdAnswer"] forState:UIControlStateNormal];
    [self.optionFour setTitle:self.poll[@"fourthAnswer"] forState:UIControlStateNormal];
    
    unsigned long optionOneCount = (unsigned long)self.poll.firstArray.count;
    unsigned long optionTwoCount = (unsigned long)self.poll.secondArray.count;
    unsigned long optionThreeCount = (unsigned long)self.poll.thirdArray.count;
    unsigned long optionFourCount = (unsigned long)self.poll.fourthArray.count;
    unsigned long total = optionOneCount + optionTwoCount + optionThreeCount + optionFourCount;
    if(total != 0){
        self.optionOnePercent.text = [NSString stringWithFormat:@"%lu%%",(optionOneCount*100)/total];
        self.optionTwoPercent.text = [NSString stringWithFormat:@"%lu%%",(optionTwoCount*100)/total];
        self.optionThreePercent.text = [NSString stringWithFormat:@"%lu%%",(optionThreeCount*100)/total];
        self.optionFourPercent.text = [NSString stringWithFormat:@"%lu%%",(optionFourCount*100)/total];
    }
    
    User *user = [PFUser currentUser];
    
    self.optionOnePercent.textColor = [UIColor blackColor];
    self.optionTwoPercent.textColor = [UIColor blackColor];
    self.optionThreePercent.textColor = [UIColor blackColor];
    self.optionFourPercent.textColor = [UIColor blackColor];
    
    if([self.poll[@"firstArray"] containsObject:user.objectId]){
        self.firstView.backgroundColor = [UIColor lightGrayColor];
    } else if ([self.poll[@"secondArray"] containsObject:user.objectId]){
        self.secondView.backgroundColor = [UIColor lightGrayColor];
    } else if ([self.poll[@"thirdArray"] containsObject:user.objectId]) {
        self.thirdView.backgroundColor = [UIColor lightGrayColor];
    } else if ([self.poll[@"fourthArray"] containsObject:user.objectId]) {
        self.fourthView.backgroundColor = [UIColor lightGrayColor];;
    } else {
        self.optionOnePercent.textColor = [UIColor whiteColor];
        self.optionTwoPercent.textColor = [UIColor whiteColor];
        self.optionThreePercent.textColor = [UIColor whiteColor];
        self.optionFourPercent.textColor = [UIColor whiteColor];
    }
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
    if(!self.keyboardUp){
        [UIView animateWithDuration: [self.keyboardDuration doubleValue] animations:^{
            CGRect textFrame = self.commentText.frame;
            textFrame.origin.y -= self.keyboardHeight;
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
        Prompt *poll = self.poll;
        comment.poll = poll;
        comment.agreesCount = 0;
        
        [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self loadQueryComments];
                self.commentText.text = @"";
                [self.view endEditing:YES];
                [self moveTextDown];
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
    [query whereKey:@"poll" equalTo:self.poll];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //make utility
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

- (IBAction)optionOneTapped:(id)sender {
    User *user = [PFUser currentUser];
    
    if(!([self.poll[@"firstArray"] containsObject:user.objectId] || [self.poll[@"secondArray"] containsObject:user.objectId] || [self.poll[@"thirdArray"] containsObject:user.objectId] || [self.poll[@"fourthArray"] containsObject:user.objectId])){
        [self.poll addUniqueObject:user.objectId forKey:@"firstArray"];
        self.firstView.backgroundColor = [UIColor lightGrayColor];
        [self.poll saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
            }
            else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
        [self updatePercents];
    }
}

- (IBAction)optionTwoTapped:(id)sender {
    User *user = [PFUser currentUser];
    
    if(!([self.poll[@"firstArray"] containsObject:user.objectId] || [self.poll[@"secondArray"] containsObject:user.objectId] || [self.poll[@"thirdArray"] containsObject:user.objectId] || [self.poll[@"fourthArray"] containsObject:user.objectId])){
        [self.poll addUniqueObject:user.objectId forKey:@"secondArray"];
        self.secondView.backgroundColor = [UIColor lightGrayColor];
        [self.poll saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
            }
            else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
        [self updatePercents];
    }
}

- (IBAction)optionThreeTapped:(id)sender {
    User *user = [PFUser currentUser];
    
    if(!([self.poll[@"firstArray"] containsObject:user.objectId] || [self.poll[@"secondArray"] containsObject:user.objectId] || [self.poll[@"thirdArray"] containsObject:user.objectId] || [self.poll[@"fourthArray"] containsObject:user.objectId])){
        [self.poll addUniqueObject:user.objectId forKey:@"thirdArray"];
        self.thirdView.backgroundColor = [UIColor lightGrayColor];
        [self.poll saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
            }
            else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
        [self updatePercents];
    }
}

- (IBAction)optionFourTapped:(id)sender {
    User *user = [PFUser currentUser];
    
    if(!([self.poll[@"firstArray"] containsObject:user.objectId] || [self.poll[@"secondArray"] containsObject:user.objectId] || [self.poll[@"thirdArray"] containsObject:user.objectId] || [self.poll[@"fourthArray"] containsObject:user.objectId])){
        [self.poll addUniqueObject:user.objectId forKey:@"fourthArray"];
        self.fourthView.backgroundColor = [UIColor lightGrayColor];
        [self.poll saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
            }
            else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
        [self updatePercents];
    }
}


- (void) updatePercents{
    unsigned long optionOneCount = (unsigned long)self.poll.firstArray.count;
    unsigned long optionTwoCount = (unsigned long)self.poll.secondArray.count;
    unsigned long optionThreeCount = (unsigned long)self.poll.thirdArray.count;
    unsigned long optionFourCount = (unsigned long)self.poll.fourthArray.count;
    unsigned long total = optionOneCount + optionTwoCount + optionThreeCount + optionFourCount;
    if(total != 0){
        self.optionOnePercent.text = [NSString stringWithFormat:@"%lu%%",(optionOneCount*100)/total];
        self.optionTwoPercent.text = [NSString stringWithFormat:@"%lu%%",(optionTwoCount*100)/total];
        self.optionThreePercent.text = [NSString stringWithFormat:@"%lu%%",(optionThreeCount*100)/total];
        self.optionFourPercent.text = [NSString stringWithFormat:@"%lu%%",(optionFourCount*100)/total];
    }
    
    self.optionOnePercent.textColor = [UIColor blackColor];
    self.optionTwoPercent.textColor = [UIColor blackColor];
    self.optionThreePercent.textColor = [UIColor blackColor];
    self.optionFourPercent.textColor = [UIColor blackColor];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"pollQuestionToComment"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.questionTableView indexPathForCell:tappedCell];
        Comment *comment = self.commentsArray[indexPath.row];
        CommentViewController *commentViewController = [segue destinationViewController];
        commentViewController.comment = comment;
    }
}

@end
