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

@property (strong, nonatomic) IBOutlet UIStepper *numberOfOptions;
@property (strong, nonatomic) IBOutlet UILabel *optionsCount;
@property (strong, nonatomic) IBOutlet UITableView *optionsTableView;
@property (strong, nonatomic) IBOutlet UITextView *questionTextBox;
@property (strong, nonatomic) IBOutlet UISegmentedControl *multipleSelection;
@property (strong, nonatomic) NSString *firstAnswer;
@property (strong, nonatomic) NSString *secondAnswer;
@property (strong, nonatomic) NSString *thirdAnswer;
@property (strong, nonatomic) NSString *fourthAnswer;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.numberOfOptions.value = 4;
    self.optionsTableView.delegate = self;
    self.optionsTableView.dataSource = self;
    [self.optionsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.submitButton.layer.cornerRadius = 0.2 * self.submitButton.bounds.size.width;
    
    if(self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight){
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
        [self.multipleSelection setTitleTextAttributes:attributes forState:UIControlStateNormal];
        NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        [self.multipleSelection setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    }
}

- (IBAction)backTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)submitTapped:(id)sender {
    [self.optionsTableView reloadData];
    bool check = true;
    if([self.questionTextBox.text isEqual: @""] || [self.firstAnswer isEqual:@""]){
        check = false;
    }
    if(self.numberOfOptions.value >= 3 && check){
        if([self.thirdAnswer isEqual:@""]){
            check = false;
        }
    }
    if(self.numberOfOptions.value == 4 && check){
        if([self.fourthAnswer isEqual:@""]){
            check = false;
        }
    }
    if(check){
        [self createPoll];
    }
}

- (IBAction)numberOfOptionsChanged:(id)sender {
    if(self.numberOfOptions.value < 2){
        self.numberOfOptions.value = 2;
    } else if(self.numberOfOptions.value > 4){
        self.numberOfOptions.value = 4;
    }
    NSString *first = [NSString stringWithFormat:@"%.f", self.numberOfOptions.value];
    NSString *second = @" options";
    self.optionsCount.text = [first stringByAppendingString:second];
    [self.optionsTableView reloadData];
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
