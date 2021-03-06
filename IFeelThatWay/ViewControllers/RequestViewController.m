//
//  RequestViewController.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import "RequestViewController.h"
#import "Request.h"
#import <lottie-ios-umbrella.h>
#import <Lottie/Lottie-Swift.h>

@interface RequestViewController ()
@property (strong, nonatomic) IBOutlet UITextView *request;
@property (strong, nonatomic) IBOutlet UIButton *requestButton;

@end

@implementation RequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.requestButton.layer.cornerRadius = 0.2 * self.requestButton.bounds.size.width;
}

- (IBAction)cancelTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)screenTapped:(id)sender {
    [self.view endEditing:true];
}

- (IBAction)submitTapped:(id)sender {
    if(![self.request.text isEqual: @""]){
        [self submitRequest];
    }
}

- (void) submitRequest {
    Request *request = [Request new];
    request.request = self.request.text;
    [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            self.request.text = @"";
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
