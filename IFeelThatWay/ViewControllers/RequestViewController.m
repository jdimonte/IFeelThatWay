//
//  RequestViewController.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import "RequestViewController.h"
#import "Request.h"

@interface RequestViewController ()
@property (strong, nonatomic) IBOutlet UITextView *request;
@property (strong, nonatomic) IBOutlet UISegmentedControl *type;

@end

@implementation RequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
}

- (void)handleSwipe {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)cancelTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)screenTapped:(id)sender {
    [self.view endEditing:true];
}

- (IBAction)submitTapped:(id)sender {
    if(![self.request.text isEqual: @""]){
        Request *request = [Request new];
        request.request = self.request.text;
        NSString *requestTypes[] = {@"topic", @"prompt"};
        request.type = requestTypes[self.type.selectedSegmentIndex];
        [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // The object has been saved.
            }
            else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
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
