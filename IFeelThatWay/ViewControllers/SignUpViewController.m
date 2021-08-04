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
@property (strong, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.signUpButton.layer.cornerRadius = 0.2 * self.signUpButton.bounds.size.width;
    if(self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){ //check if it is dark mode
        self.email.layer.borderColor = [UIColor colorNamed:@"loginoutline"].CGColor;
        self.email.layer.borderWidth = 3.0f;
        self.email.layer.cornerRadius = 7.0f;
        self.username.layer.borderColor = [UIColor colorNamed:@"loginoutline"].CGColor;
        self.username.layer.borderWidth = 3.0f;
        self.username.layer.cornerRadius = 7.0f;
        self.password.layer.borderColor = [UIColor colorNamed:@"loginoutline"].CGColor;
        self.password.layer.borderWidth = 3.0f;
        self.password.layer.cornerRadius = 7.0f;
        self.confirmPassword.layer.borderColor = [UIColor colorNamed:@"loginoutline"].CGColor;
        self.confirmPassword.layer.borderWidth = 3.0f;
        self.confirmPassword.layer.cornerRadius = 7.0f;
    }
}

- (IBAction)backTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)signInTapped:(id)sender {
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
