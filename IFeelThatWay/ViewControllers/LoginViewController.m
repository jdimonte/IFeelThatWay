//
//  LoginViewController.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "LoginUtil.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginButton.layer.cornerRadius = 0.2 * self.loginButton.bounds.size.width;
}

- (IBAction)loginTapped:(id)sender {
    User *currentUser = [User new];
    currentUser.username = self.username.text;
    currentUser.password = self.password.text;
    [LoginUtil loginUser:currentUser:self];
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
