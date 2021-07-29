//
//  CreateViewController.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/26/21.
//

#import "CreateViewController.h"
#import "OptionCell.h"
#import "Prompt.h"
#import "Poll.h"

@interface CreateViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UISegmentedControl *postType;
@property (strong, nonatomic) IBOutlet UIStepper *numberOfOptions;
@property (strong, nonatomic) IBOutlet UILabel *optionsCount;
@property (strong, nonatomic) IBOutlet UITableView *optionsTableView;
@property (strong, nonatomic) IBOutlet UITextView *questionTextBox;
@property (strong, nonatomic) IBOutlet UISegmentedControl *multipleSelection;
@property (strong, nonatomic) NSString *firstAnswer;
@property (strong, nonatomic) NSString *secondAnswer;
@property (strong, nonatomic) NSString *thirdAnswer;
@property (strong, nonatomic) NSString *fourthAnswer;

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.numberOfOptions.value = 4;
    self.optionsTableView.delegate = self;
    self.optionsTableView.dataSource = self;
    [self.optionsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (IBAction)backTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)submitTapped:(id)sender {
    [self.optionsTableView reloadData];
    NSString *postTypes[] = {@"prompt", @"poll"};
    NSString *type = postTypes[self.postType.selectedSegmentIndex];
    if([type isEqual:@"prompt"]){
        if(![self.questionTextBox.text isEqual: @""]){
            [self createPrompt];
        }
    }
    else {
        if(![self.questionTextBox.text isEqual: @""] && ![self.firstAnswer isEqual:@""] && ![self.secondAnswer isEqual:@""] && ![self.thirdAnswer isEqual:@""] && ![self.fourthAnswer isEqual:@""]){
            [self createPoll];
        }
    }
}

- (IBAction)numberOfOptionsChanged:(id)sender {
    if(self.numberOfOptions.value < 2){
        self.numberOfOptions.value = 2;
    } else if(self.numberOfOptions.value > 5){
        self.numberOfOptions.value = 5;
    }
    NSString *first = [NSString stringWithFormat:@"%.f", self.numberOfOptions.value];
    NSString *second = @" options";
    self.optionsCount.text = [first stringByAppendingString:second];
    [self.optionsTableView reloadData];
}

- (void) createPrompt {
    Prompt *prompt = [Prompt new];
    prompt.question = self.questionTextBox.text;
    prompt.topic = self.topic;
    [prompt saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self dismissViewControllerAnimated:true completion:nil];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void) createPoll {
    Poll *poll = [Poll new];
    bool *multipleSelectionChoice[] = {false, true};
    bool *multipleSelectionForPoll = multipleSelectionChoice[self.multipleSelection.selectedSegmentIndex];
    poll.question = self.questionTextBox.text;
    poll.topic = self.topic;
    poll.multipleSelection = multipleSelectionForPoll;
    poll.firstAnswer = self.firstAnswer;
    poll.secondAnswer = self.secondAnswer;
    poll.thirdAnswer = self.thirdAnswer;
    poll.fourthAnswer = self.fourthAnswer;
    [poll saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self dismissViewControllerAnimated:true completion:nil];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.numberOfOptions.value;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OptionCell *cell = (OptionCell *)[tableView dequeueReusableCellWithIdentifier:@"OptionCell" forIndexPath:indexPath];
    NSString *first = @"Option ";
    NSString *second = [NSString stringWithFormat:@"%ld", indexPath.row+1];
    cell.optionNumber.text = [first stringByAppendingString:second];
    if(indexPath.row == 0){
        self.firstAnswer = cell.optionInput.text;
    }
    if(indexPath.row == 1){
        self.secondAnswer = cell.optionInput.text;
    }
    if(indexPath.row == 2){
        self.thirdAnswer = cell.optionInput.text;
    }
    if(indexPath.row == 3){
        self.fourthAnswer = cell.optionInput.text;
    }
    return cell;
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
