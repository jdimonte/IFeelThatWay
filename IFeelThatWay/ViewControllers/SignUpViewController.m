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
@property (strong, nonatomic) IBOutlet UIImageView *emailIcon;
@property (strong, nonatomic) IBOutlet UIImageView *usernameIcon;
@property (strong, nonatomic) IBOutlet UIImageView *passwordIcon;
@property (strong, nonatomic) IBOutlet UIImageView *confirmPasswordIcon;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.signUpButton.layer.cornerRadius = 0.2 * self.signUpButton.bounds.size.width;
    if(self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){
        [self darkModeDesign];
    }
    
    [self textFieldDesign];
}

- (void) darkModeDesign {
    self.email.layer.borderColor = [UIColor colorNamed:@"pink"].CGColor;
    self.email.layer.borderWidth = 3.0f;
    self.email.layer.cornerRadius = 7.0f;
    self.username.layer.borderColor = [UIColor colorNamed:@"pink"].CGColor;
    self.username.layer.borderWidth = 3.0f;
    self.username.layer.cornerRadius = 7.0f;
    self.password.layer.borderColor = [UIColor colorNamed:@"pink"].CGColor;
    self.password.layer.borderWidth = 3.0f;
    self.password.layer.cornerRadius = 7.0f;
    self.confirmPassword.layer.borderColor = [UIColor colorNamed:@"pink"].CGColor;
    self.confirmPassword.layer.borderWidth = 3.0f;
    self.confirmPassword.layer.cornerRadius = 7.0f;
}

- (void) textFieldDesign {
    UIView *emailPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
    self.email.rightView = emailPaddingView;
    self.email.rightViewMode = UITextFieldViewModeAlways;
    UIView *usernamePaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
    self.username.rightView = usernamePaddingView;
    self.username.rightViewMode = UITextFieldViewModeAlways;
    UIView *passwordPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
    self.password.rightView = passwordPaddingView;
    self.password.rightViewMode = UITextFieldViewModeAlways;
    UIView *confirmPasswordPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
    self.confirmPassword.rightView = confirmPasswordPaddingView;
    self.confirmPassword.rightViewMode = UITextFieldViewModeAlways;
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

- (IBAction)emailChanged:(id)sender {
    if(![self.email.text isEqual:@""]){
        [self.emailIcon setTintColor:[UIColor blackColor]];
    }
    else{
        [self.emailIcon setTintColor:[UIColor systemGray5Color]];
    }
}

- (IBAction)usernameChanged:(id)sender {
    if(![self.username.text isEqual:@""]){
        [self.usernameIcon setTintColor:[UIColor blackColor]];
    }
    else{
        [self.usernameIcon setTintColor:[UIColor systemGray5Color]];
    }
}

- (IBAction)passwordChanged:(id)sender {
    if(![self.password.text isEqual:@""]){
        [self.passwordIcon setTintColor:[UIColor blackColor]];
    }
    else{
        [self.passwordIcon setTintColor:[UIColor systemGray5Color]];
    }
}

- (IBAction)confirmPasswordChanged:(id)sender {
    if(![self.confirmPassword.text isEqual:@""] && [self.confirmPassword.text isEqual:self.password.text]){
        [self.confirmPasswordIcon setTintColor:[UIColor blackColor]];
    }
    else{
        [self.confirmPasswordIcon setTintColor:[UIColor systemGray5Color]];
    }
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
