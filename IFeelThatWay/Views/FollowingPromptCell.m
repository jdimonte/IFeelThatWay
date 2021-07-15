//
//  FollowingPromptCell.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/14/21.
//

#import "FollowingPromptCell.h"
#import "User.h"

@implementation FollowingPromptCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)handRaiseButtonTapped:(id)sender {
    User *user = [PFUser currentUser];
    if(![self.promptCell[@"agreesArray"] containsObject: user.objectId]){
        [self.handRaiseButton setImage:[UIImage systemImageNamed:@"hand.raised.fill"] forState:UIControlStateNormal];
        [self.promptCell addUniqueObject:user.objectId forKey:@"agreesArray"];
    }
    else{
        [self.handRaiseButton setImage:[UIImage systemImageNamed:@"hand.raised"] forState:UIControlStateNormal];
        [self.promptCell removeObject:user.objectId forKey:@"agreesArray"];
    }
    [self.promptCell saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}
- (IBAction)saveButtonTapped:(id)sender {
    User *user = [PFUser currentUser];
    if(![self.promptCell[@"savesArray"] containsObject: user.objectId]){
        [self.saveButton setImage:[UIImage systemImageNamed:@"bookmark.fill"] forState:UIControlStateNormal];
        [self.promptCell addUniqueObject:user.objectId forKey:@"savesArray"];
    }
    else{
        [self.saveButton setImage:[UIImage systemImageNamed:@"bookmark"] forState:UIControlStateNormal];
        [self.promptCell removeObject:user.objectId forKey:@"savesArray"];
    }
    [self.promptCell saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

@end
