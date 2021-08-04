//
//  CreatePromptViewController.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 8/3/21.
//

#import "CreatePromptViewController.h"
#import "Prompt.h"
#import "User.h"

@interface CreatePromptViewController ()

@property (strong, nonatomic) IBOutlet UITextView *questionTextBox;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation CreatePromptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.submitButton.layer.cornerRadius = 0.2 * self.submitButton.bounds.size.width;
}

- (IBAction)backTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)submitTapped:(id)sender {
    if(![self.questionTextBox.text isEqual: @""]){
        [self createPrompt];
    }
}

- (void) createPrompt {
    User *user = [PFUser currentUser];
    Prompt *prompt = [Prompt new];
    prompt.question = self.questionTextBox.text;
    prompt.topic = self.topic;
    prompt.createdBy = user;
    [prompt saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self dismissViewControllerAnimated:true completion:nil];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
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
