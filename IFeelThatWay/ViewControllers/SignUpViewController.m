//
//  SignUpViewController.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import "SignUpViewController.h"
#import "SignUpUtil.h"
#import <Parse/Parse.h>

@interface SignUpViewController ()
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *confirmPassword;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
}

- (void)handleSwipe {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)backTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)signUpTapped:(id)sender {
    PFUser *newUser = [PFUser user];
    newUser.email = self.email.text;
    newUser.username = self.username.text;
    newUser.password = self.password.text;
    [SignUpUtil registerUser:newUser:self];
}

- (IBAction)screenTapped:(id)sender {
    [self.view endEditing:true];
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
