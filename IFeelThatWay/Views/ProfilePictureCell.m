//
//  ProfilePictureCell.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 8/2/21.
//

#import "ProfilePictureCell.h"
#import "User.h"

@implementation ProfilePictureCell

- (void) updateProfilePicture: (NSString *)color {
    User *user = [PFUser currentUser];
    UIImage * colorPicture = [UIImage imageNamed:color];
    [self.displayedPicture setImage:colorPicture];
    [UIView animateWithDuration:1
                     animations:^{
        self.displayedPicture.transform = CGAffineTransformMakeScale(1.5, 1.5);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:1
                                          animations:^{
                             self.displayedPicture.transform = CGAffineTransformIdentity;
                                              
                                          }];
                     }];
    user[@"profilePicture"] = color;
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"fail");
        } else {
            NSLog(@"success");
        }
    }];
}
- (IBAction)imageTapped:(id)sender {
    NSString *color = self.colorsArray[self.index];
    [self updateProfilePicture:color];
}


@end
