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
#import "Report.h"
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
@property int optionOneChange;
@property int optionTwoChange;
@property int optionThreeChange;
@property int optionFourChange;

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

- (IBAction)backTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void) designPoll {
    self.firstView.layer.cornerRadius = 0.05 * self.firstView.bounds.size.width;
    self.secondView.layer.cornerRadius = 0.05 * self.secondView.bounds.size.width;
    self.thirdView.layer.cornerRadius = 0.05 * self.thirdView.bounds.size.width;
    self.fourthView.layer.cornerRadius = 0.05 * self.fourthView.bounds.size.width;
    
    self.question.text = self.poll[@"question"];
    [self.optionOne setTitle:self.poll[@"firstAnswer"] forState:UIControlStateNormal];
    [self.optionTwo setTitle:self.poll[@"secondAnswer"] forState:UIControlStateNormal];
    [self.optionThree setTitle:self.poll[@"thirdAnswer"] forState:UIControlStateNormal];
    [self.optionFour setTitle:self.poll[@"fourthAnswer"] forState:UIControlStateNormal];
    
    User *user = [PFUser currentUser];
    bool answered = [self.poll[@"firstArray"] containsObject:user.objectId] || [self.poll[@"secondArray"] containsObject:user.objectId] || [self.poll[@"thirdArray"] containsObject:user.objectId] || [self.poll[@"fourthArray"] containsObject:user.objectId];
    if(answered){
        self.optionOnePercent.textColor = [UIColor blackColor];
        self.optionTwoPercent.textColor = [UIColor blackColor];
        self.optionThreePercent.textColor = [UIColor blackColor];
        self.optionFourPercent.textColor = [UIColor blackColor];
    } else {
        self.optionOnePercent.textColor = [UIColor whiteColor];
        self.optionTwoPercent.textColor = [UIColor whiteColor];
        self.optionThreePercent.textColor = [UIColor whiteColor];
        self.optionFourPercent.textColor = [UIColor whiteColor];
    }
    
    unsigned long optionOneCount = (unsigned long)self.poll.firstArray.count;
    unsigned long optionTwoCount = (unsigned long)self.poll.secondArray.count;
    unsigned long optionThreeCount = (unsigned long)self.poll.thirdArray.count;
    unsigned long optionFourCount = (unsigned long)self.poll.fourthArray.count;
    unsigned long total = optionOneCount + optionTwoCount + optionThreeCount + optionFourCount;
    if(total != 0 && answered){
        if([self.poll[@"firstPlace"] isEqual: @1]){
            self.optionOnePercent.text = [NSString stringWithFormat:@"%lu%%",(optionOneCount*100)/total];
            [self.optionOne setTitle:self.poll[@"firstAnswer"] forState:UIControlStateNormal];
            if([self.poll[@"firstArray"] containsObject:user.objectId]){
                self.firstView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
                [self.optionOne setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
                self.optionOnePercent.textColor = [UIColor whiteColor];
            }
            
        } else if([self.poll[@"firstPlace"] isEqual: @2]){
            self.optionTwoPercent.text = [NSString stringWithFormat:@"%lu%%",(optionOneCount*100)/total];
            [self.optionTwo setTitle:self.poll[@"firstAnswer"] forState:UIControlStateNormal];
            if([self.poll[@"firstArray"] containsObject:user.objectId]){
                self.secondView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
                [self.optionTwo setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
                self.optionTwoPercent.textColor = [UIColor whiteColor];
            }
            
        } else if([self.poll[@"firstPlace"] isEqual: @3]){
            self.optionThreePercent.text = [NSString stringWithFormat:@"%lu%%",(optionOneCount*100)/total];
            [self.optionThree setTitle:self.poll[@"firstAnswer"] forState:UIControlStateNormal];
            if([self.poll[@"firstArray"] containsObject:user.objectId]){
                self.thirdView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
                [self.optionThree setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
                self.optionThreePercent.textColor = [UIColor whiteColor];
            }
        } else { //-180
            self.optionFourPercent.text = [NSString stringWithFormat:@"%lu%%",(optionOneCount*100)/total];
            [self.optionFour setTitle:self.poll[@"firstAnswer"] forState:UIControlStateNormal];
            if([self.poll[@"firstArray"] containsObject:user.objectId]){
                self.fourthView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
                [self.optionFour setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
                self.optionFourPercent.textColor = [UIColor whiteColor];
            }
        }
        
        if([self.poll[@"secondPlace"] isEqual: @2]){
            self.optionTwoPercent.text = [NSString stringWithFormat:@"%lu%%",(optionTwoCount*100)/total];
            [self.optionTwo setTitle:self.poll[@"secondAnswer"] forState:UIControlStateNormal];
            if ([self.poll[@"secondArray"] containsObject:user.objectId]){
                self.secondView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
                [self.optionTwo setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
                self.optionTwoPercent.textColor = [UIColor whiteColor];
            }
        } else if([self.poll[@"secondPlace"] isEqual: @3]){
            self.optionThreePercent.text = [NSString stringWithFormat:@"%lu%%",(optionTwoCount*100)/total];
            [self.optionThree setTitle:self.poll[@"secondAnswer"] forState:UIControlStateNormal];
            if ([self.poll[@"secondArray"] containsObject:user.objectId]){
                self.thirdView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
                [self.optionThree setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
                self.optionThreePercent.textColor = [UIColor whiteColor];
            }
        } else if([self.poll[@"secondPlace"] isEqual: @4]){
            self.optionFourPercent.text = [NSString stringWithFormat:@"%lu%%",(optionTwoCount*100)/total];
            [self.optionFour setTitle:self.poll[@"secondAnswer"] forState:UIControlStateNormal];
            if ([self.poll[@"secondArray"] containsObject:user.objectId]){
                self.fourthView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
                [self.optionFour setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
                self.optionFourPercent.textColor = [UIColor whiteColor];
            }
        } else { //60
            self.optionOnePercent.text = [NSString stringWithFormat:@"%lu%%",(optionTwoCount*100)/total];
            [self.optionOne setTitle:self.poll[@"secondAnswer"] forState:UIControlStateNormal];
            if ([self.poll[@"secondArray"] containsObject:user.objectId]){
                self.firstView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
                [self.optionOne setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
                self.optionOnePercent.textColor = [UIColor whiteColor];
            }
        }
        
        if([self.poll[@"thirdPlace"] isEqual: @3]){
            self.optionThreePercent.text = [NSString stringWithFormat:@"%lu%%",(optionThreeCount*100)/total];
            [self.optionThree setTitle:self.poll[@"thirdAnswer"] forState:UIControlStateNormal];
            if ([self.poll[@"thirdArray"] containsObject:user.objectId]) {
                self.thirdView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
                [self.optionThree setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
                self.optionThreePercent.textColor = [UIColor whiteColor];
            }
        } else if([self.poll[@"thirdPlace"] isEqual: @4]){
            self.optionFourPercent.text = [NSString stringWithFormat:@"%lu%%",(optionThreeCount*100)/total];
            [self.optionFour setTitle:self.poll[@"thirdAnswer"] forState:UIControlStateNormal];
            if ([self.poll[@"thirdArray"] containsObject:user.objectId]) {
                self.fourthView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
                [self.optionFour setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
                self.optionFourPercent.textColor = [UIColor whiteColor];
            }
        } else if([self.poll[@"thirdPlace"] isEqual: @2]){
            self.optionTwoPercent.text = [NSString stringWithFormat:@"%lu%%",(optionThreeCount*100)/total];
            [self.optionTwo setTitle:self.poll[@"thirdAnswer"] forState:UIControlStateNormal];
            if ([self.poll[@"thirdArray"] containsObject:user.objectId]) {
                self.secondView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
                [self.optionTwo setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
                self.optionTwoPercent.textColor = [UIColor whiteColor];
            }
        } else { //120
            self.optionOnePercent.text = [NSString stringWithFormat:@"%lu%%",(optionThreeCount*100)/total];
            [self.optionOne setTitle:self.poll[@"thirdAnswer"] forState:UIControlStateNormal];
            if ([self.poll[@"thirdArray"] containsObject:user.objectId]) {
                self.firstView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
                [self.optionOne setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
                self.optionOnePercent.textColor = [UIColor whiteColor];
            }
        }
        
        if([self.poll[@"fourthPlace"] isEqual: @4]){
            self.optionFourPercent.text = [NSString stringWithFormat:@"%lu%%",(optionFourCount*100)/total];
            [self.optionFour setTitle:self.poll[@"fourthAnswer"] forState:UIControlStateNormal];
            if ([self.poll[@"fourthArray"] containsObject:user.objectId]) {
                self.fourthView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
                [self.optionFour setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
                self.optionFourPercent.textColor = [UIColor whiteColor];
            }
        } else if([self.poll[@"fourthPlace"] isEqual: @3]){
            self.optionThreePercent.text = [NSString stringWithFormat:@"%lu%%",(optionFourCount*100)/total];
            [self.optionThree setTitle:self.poll[@"fourthAnswer"] forState:UIControlStateNormal];
            if ([self.poll[@"fourthArray"] containsObject:user.objectId]) {
                self.thirdView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
                [self.optionThree setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
                self.optionThreePercent.textColor = [UIColor whiteColor];
            }
        } else if([self.poll[@"fourthPlace"] isEqual: @2]){
            self.optionTwoPercent.text = [NSString stringWithFormat:@"%lu%%",(optionFourCount*100)/total];
            [self.optionTwo setTitle:self.poll[@"fourthAnswer"] forState:UIControlStateNormal];
            if ([self.poll[@"fourthArray"] containsObject:user.objectId]) {
                self.secondView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
                [self.optionTwo setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
                self.optionTwoPercent.textColor = [UIColor whiteColor];
            }
        } else { //180
            self.optionOnePercent.text = [NSString stringWithFormat:@"%lu%%",(optionFourCount*100)/total];
            [self.optionOne setTitle:self.poll[@"fourthAnswer"] forState:UIControlStateNormal];
            if ([self.poll[@"fourthArray"] containsObject:user.objectId]) {
                self.firstView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
                [self.optionOne setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
                self.optionOnePercent.textColor = [UIColor whiteColor];
            }
        }
    }
}

- (IBAction)commentTextBoxTapped:(UITapGestureRecognizer *)sender {
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
            textFrame.origin.y += self.keyboardHeight;
            self.commentText.frame = textFrame;
            CGRect buttonFrame = self.commentButton.frame;
            buttonFrame.origin.y += self.keyboardHeight;
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
        Poll *poll = self.poll;
        comment.poll = poll;
        comment.agreesCount = 0;
        
        [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self loadQueryComments];
                self.commentText.text = @"";
                [self.view endEditing:YES];
                [self moveTextDown];
                
                if(!self.poll.hasComments){
                    self.poll.hasComments = !self.poll.hasComments;
                    [self.poll saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
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
        self.firstView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
        [self.optionOne setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
        [self.poll saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
            }
            else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
        [self updatePercents];
        self.optionOnePercent.textColor = [UIColor whiteColor];
    }
}

- (IBAction)optionTwoTapped:(id)sender {
    User *user = [PFUser currentUser];
    
    if(!([self.poll[@"firstArray"] containsObject:user.objectId] || [self.poll[@"secondArray"] containsObject:user.objectId] || [self.poll[@"thirdArray"] containsObject:user.objectId] || [self.poll[@"fourthArray"] containsObject:user.objectId])){
        [self.poll addUniqueObject:user.objectId forKey:@"secondArray"];
        self.secondView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
        [self.optionTwo setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
        [self.poll saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
            }
            else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
        [self updatePercents];
        self.optionTwoPercent.textColor = [UIColor whiteColor];
    }
}

- (IBAction)optionThreeTapped:(id)sender {
    User *user = [PFUser currentUser];
    
    if(!([self.poll[@"firstArray"] containsObject:user.objectId] || [self.poll[@"secondArray"] containsObject:user.objectId] || [self.poll[@"thirdArray"] containsObject:user.objectId] || [self.poll[@"fourthArray"] containsObject:user.objectId])){
        [self.poll addUniqueObject:user.objectId forKey:@"thirdArray"];
        self.thirdView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
        [self.optionThree setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
        [self.poll saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
            }
            else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
        [self updatePercents];
        self.optionThreePercent.textColor = [UIColor whiteColor];
    }
}

- (IBAction)optionFourTapped:(id)sender {
    User *user = [PFUser currentUser];
    
    if(!([self.poll[@"firstArray"] containsObject:user.objectId] || [self.poll[@"secondArray"] containsObject:user.objectId] || [self.poll[@"thirdArray"] containsObject:user.objectId] || [self.poll[@"fourthArray"] containsObject:user.objectId])){
        [self.poll addUniqueObject:user.objectId forKey:@"fourthArray"];
        self.fourthView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
        [self.optionFour setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
        [self.poll saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
            }
            else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
        [self updatePercents];
        self.optionFourPercent.textColor = [UIColor whiteColor];
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
    
    unsigned long firstPlace = MAX(optionOneCount,MAX(optionTwoCount,MAX(optionThreeCount,optionFourCount)));
    if(optionOneCount == firstPlace){
        self.optionOneChange = 0;
        unsigned long secondPlace = MAX(optionTwoCount,MAX(optionThreeCount,optionFourCount));
        if(secondPlace == optionTwoCount){
            self.optionTwoChange = 0;
            if(optionThreeCount > optionFourCount){
                self.optionThreeChange = 0;
                self.optionFourChange = 0;
                [self updatePlaces:1:2:3:4];
            } else {
                self.optionThreeChange = -60;
                self.optionFourChange = 60;
                [self updatePlaces:1:2:4:3];
            }
        } else if(secondPlace == optionThreeCount){
            self.optionThreeChange = 60;
            if(optionTwoCount > optionFourCount){
                self.optionTwoChange = -60;
                self.optionFourChange = 0;
                [self updatePlaces:1:3:2:4];
            } else {
                self.optionTwoChange = -120;
                self.optionFourChange = 60;
                [self updatePlaces:1:4:2:3];
            }
        } else {
            self.optionFourChange = 120;
            if(optionThreeCount > optionTwoCount){
                self.optionThreeChange = 0;
                self.optionTwoChange = -120;
                [self updatePlaces:1:4:3:2];
            } else {
                self.optionThreeChange = -60;
                self.optionTwoChange = -60;
                [self updatePlaces:1:3:4:2];
            }
        }
    }
    else if(optionTwoCount == firstPlace){
        self.optionTwoChange = 60;
        unsigned long secondPlace = MAX(optionOneCount,MAX(optionThreeCount,optionFourCount));
        if(secondPlace == optionOneCount){
            self.optionOneChange = -60;
            if(optionThreeCount > optionFourCount){
                self.optionThreeChange = 0;
                self.optionFourChange = 0;
                [self updatePlaces:2:1:3:4];
            } else {
                self.optionThreeChange = -60;
                self.optionFourChange = 60;
                [self updatePlaces:2:1:4:3];
            }
        } else if(secondPlace == optionThreeCount){
            self.optionThreeChange = 60;
            if(optionOneCount > optionFourCount){
                self.optionOneChange = -120;
                self.optionFourChange = 0;
                [self updatePlaces:3:1:2:4];
            } else {
                self.optionOneChange = -180;
                self.optionFourChange = 60;
                [self updatePlaces:4:1:2:3];
            }
        } else {
            self.optionFourChange = 120;
            if(optionThreeCount > optionOneCount){
                self.optionThreeChange = 0;
                self.optionOneChange = -180;
                [self updatePlaces:4:1:3:2];
            } else {
                self.optionThreeChange = -60;
                self.optionOneChange = -120;
                [self updatePlaces:3:1:4:2];
            }
        }
    }
    else if(optionThreeCount == firstPlace){
        self.optionThreeChange = 120;
        unsigned long secondPlace = MAX(optionTwoCount,MAX(optionOneCount,optionFourCount));
        if(secondPlace == optionTwoCount){
            self.optionTwoChange = 0;
            if(optionOneCount > optionFourCount){
                self.optionOneChange = -120;
                self.optionFourChange = 0;
                [self updatePlaces:3:2:1:4];
            } else {
                self.optionOneChange = -180;
                self.optionFourChange = 60;
                [self updatePlaces:4:2:1:3];
            }
        } else if(secondPlace == optionOneCount){
            self.optionOneChange = -60;
            if(optionTwoCount > optionFourCount){
                self.optionTwoChange = -60;
                self.optionFourChange = 0;
                [self updatePlaces:2:3:1:3];
            } else {
                self.optionTwoChange = -120;
                self.optionFourChange = 60;
                [self updatePlaces:2:4:1:3];
            }
        } else {
            self.optionFourChange = 120;
            if(optionOneCount > optionTwoCount){
                self.optionOneChange = -120;
                self.optionTwoChange = -120;
                [self updatePlaces:3:4:1:2];
            } else {
                self.optionOneChange = -180;
                self.optionTwoChange = -60;
                [self updatePlaces:4:3:1:2];
            }
        }
    }
    else{
        self.optionFourChange = 180;
        unsigned long secondPlace = MAX(optionTwoCount,MAX(optionThreeCount,optionOneCount));
        if(secondPlace == optionTwoCount){
            self.optionTwoChange = 0;
            if(optionThreeCount > optionOneCount){
                self.optionThreeChange = 0;
                self.optionOneChange = -180;
                [self updatePlaces:4:2:3:1];
            } else {
                self.optionThreeChange = -60;
                self.optionOneChange = -120;
                [self updatePlaces:3:2:4:1];
            }
        } else if(secondPlace == optionThreeCount){
            self.optionThreeChange = 60;
            if(optionOneCount > optionTwoCount){
                self.optionOneChange = -120;
                self.optionTwoChange = -120;
                [self updatePlaces:3:4:2:1];
            } else {
                self.optionOneChange = -180;
                self.optionTwoChange = -60;
                [self updatePlaces:4:3:2:1];
            }
        } else {
            self.optionOneChange = -60;
            if(optionThreeCount > optionTwoCount){
                self.optionThreeChange = 0;
                self.optionTwoChange = -120;
                [self updatePlaces:2:4:3:1];
            } else {
                self.optionThreeChange = -60;
                self.optionTwoChange = -60;
                [self updatePlaces:2:3:4:1];
            }
        }
    }
    
    [UIView animateWithDuration: 1 animations:^{
        CGRect firstFrame = self.firstView.frame;
        firstFrame.origin.y -= self.optionOneChange;
        self.firstView.frame = firstFrame;
        
        CGRect secondFrame = self.secondView.frame;
        secondFrame.origin.y -= self.optionTwoChange;
        self.secondView.frame = secondFrame;
        
        CGRect thirdFrame = self.thirdView.frame;
        thirdFrame.origin.y -= self.optionThreeChange;
        self.thirdView.frame = thirdFrame;
        
        CGRect fourthFrame = self.fourthView.frame;
        fourthFrame.origin.y -= self.optionFourChange;
        self.fourthView.frame = fourthFrame;
    }];
}

- (void) updatePlaces:(unsigned long)oneLocation:(unsigned long)twoLocation:(unsigned long)threeLocation:(unsigned long)fourLocation{
    self.poll.firstPlace = @(oneLocation);
    self.poll.secondPlace = @(twoLocation);
    self.poll.thirdPlace = @(threeLocation);
    self.poll.fourthPlace = @(fourLocation);
    [self.poll saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self moveTextDown];
    if ([segue.identifier isEqual:@"pollQuestionToComment"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.questionTableView indexPathForCell:tappedCell];
        Comment *comment = self.commentsArray[indexPath.row];
        CommentViewController *commentViewController = [segue destinationViewController];
        commentViewController.comment = comment;
    }
}

@end
