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

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.numberOfOptions.value = 4;
    self.optionsTableView.delegate = self;
    self.optionsTableView.dataSource = self;
}

- (IBAction)backTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)submitTapped:(id)sender {
    NSString *postTypes[] = {@"prompt", @"poll"};
    NSString *type = postTypes[self.postType.selectedSegmentIndex];
    if([type isEqual:@"prompt"]){
        Prompt *prompt = [Prompt new];
        prompt.question = self.questionTextBox.text;
        [prompt saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
            }
            else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
    else {
        Poll *poll = [Poll new];
        poll.question = self.questionTextBox.text;
        //get options
        [poll saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
            }
            else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
}

- (IBAction)numberOfOptionsChanged:(id)sender {
    if(self.numberOfOptions.value < 2){
        self.numberOfOptions.value = 2;
    } else if(self.numberOfOptions.value > 5){
        self.numberOfOptions.value = 5;
    }
    //update labels
    NSString *first = [NSString stringWithFormat:@"%.f", self.numberOfOptions.value];
    NSString *second = @" options";
    self.optionsCount.text = [first stringByAppendingString:second];
    //reload table view
    [self.optionsTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.numberOfOptions.value;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OptionCell *cell = (OptionCell *)[tableView dequeueReusableCellWithIdentifier:@"OptionCell" forIndexPath:indexPath];
    NSString *first = @"Option ";
    NSString *second = [NSString stringWithFormat:@"%ld", indexPath.row+1];
    cell.optionNumber.text = [first stringByAppendingString:second];
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
