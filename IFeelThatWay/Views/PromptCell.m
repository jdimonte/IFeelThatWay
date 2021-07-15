//
//  PromptCell.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/13/21.
//

#import "PromptCell.h"
#import "User.h"

@implementation PromptCell

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
        [self.handRaise setImage:[UIImage systemImageNamed:@"hand.raised.fill"] forState:UIControlStateNormal];
        [self.promptCell addUniqueObject:user.objectId forKey:@"agreesArray"];
    }
    else{
        [self.handRaise setImage:[UIImage systemImageNamed:@"hand.raised"] forState:UIControlStateNormal];
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
        [self.save setImage:[UIImage systemImageNamed:@"bookmark.fill"] forState:UIControlStateNormal];
        [self.promptCell addUniqueObject:user.objectId forKey:@"savesArray"];
    }
    else{
        [self.save setImage:[UIImage systemImageNamed:@"bookmark"] forState:UIControlStateNormal];
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
